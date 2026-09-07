#!/usr/bin/env python3
"""Check clean and incremental generation in an isolated consumer package."""

import argparse
import json
import re
from pathlib import Path
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--analyzer", help="Analyzer version or constraint to test")
parser.add_argument("--build-runner", help="build_runner version or constraint to test")
parser.add_argument("--freezed", help="Freezed version or constraint to test")
parser.add_argument("--json-serializable", help="JSON Serializable version or constraint to test")
parser.add_argument("--json-annotation", help="JSON Annotation version or constraint to test")
options = parser.parse_args()


def run(directory, *command):
    subprocess.run(command, cwd=directory, check=True)


def check_outputs(directory, stem, field):
    for suffix in ("dart", "freezed.dart", "g.dart"):
        output = directory / "lib" / f"{stem}.supabase.{suffix}"
        assert output.is_file(), f"Missing {output.name}"
        assert field in output.read_text(), f"Missing {field} in {output.name}"


with tempfile.TemporaryDirectory(prefix="supabase-codegen-") as temporary:
    fixture = Path(temporary)
    (fixture / "lib").mkdir()
    # Reuse the example dependency versions, with absolute local package paths.
    pubspec = (ROOT / "supabase_schema/example/pubspec.yaml").read_text()
    for name in ("supabase_schema_generator", "supabase_schema"):
        pubspec = pubspec.replace(f"path: ../../{name}\n", f"path: {json.dumps(str(ROOT / name))}\n")
    # Normal dependency constraints, never overrides: an incompatible combination
    # must fail resolution rather than bypass a generator's declared support.
    for package, version in (
        ("build_runner", options.build_runner),
        ("freezed", options.freezed),
        ("json_serializable", options.json_serializable),
        ("json_annotation", options.json_annotation),
    ):
        if version:
            pubspec = re.sub(rf"(?m)^  {package}: .*?$", f"  {package}: {json.dumps(version)}", pubspec)
    if options.analyzer:
        pubspec = pubspec.replace("dev_dependencies:\n", f"dev_dependencies:\n  analyzer: {json.dumps(options.analyzer)}\n")
    (fixture / "pubspec.yaml").write_text(pubspec)
    schema = fixture / "lib/schema.dart"
    schema.write_text((ROOT / "supabase_schema/example/lib/schema.dart").read_text())
    # This generated library depends on another generated model on the first run.
    (fixture / "lib/profile.dart").write_text("""
import 'package:supabase_schema/supabase_schema.dart';
import 'schema.supabase.dart';

@Schema(tableName: 'profiles', baseModelName: 'Profile')
class ProfileSchema extends SupabaseSchema {
  final id = Field.intId().aliasAs('ProfileId');
  final owner = Field.join<User>().withForeignKey('owner_id');

  @override
  List<Model> get models => [
    Model('ProfileSummary').inheritAllFromBase(excepts: [owner]),
  ];
}
""")
    run(fixture, "flutter", "pub", "get")
    run(fixture, "dart", "run", "build_runner", "build")
    check_outputs(fixture, "schema", "email")
    check_outputs(fixture, "profile", "owner")
    profile = (fixture / "lib/profile.supabase.dart").read_text()
    assert "required User owner" in profile
    summary = profile.split("sealed class ProfileSummary", 1)[1]
    assert "required ProfileId id" in summary and "required User owner" not in summary
    run(fixture, "dart", "analyze", "lib")

    schema.write_text(schema.read_text().replace(
        "  final email =", "  final nickname = Field<String>('nickname');\n  final email ="
    ))
    run(fixture, "dart", "run", "build_runner", "build")
    check_outputs(fixture, "schema", "nickname")
    run(fixture, "dart", "analyze", "lib")

    # A build with unchanged inputs must leave the outputs unchanged.
    outputs = {p: p.read_bytes() for p in (fixture / "lib").glob("*.supabase*.dart")}
    run(fixture, "dart", "run", "build_runner", "build")
    assert all(p.read_bytes() == content for p, content in outputs.items())

print("Clean, cross-schema, incremental, and unchanged-input builds passed.")

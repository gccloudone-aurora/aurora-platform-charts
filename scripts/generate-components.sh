#!/usr/bin/env bash
set -euo pipefail

# Script to auto-generate COMPONENTS.md and components.json from component metadata
# This ensures component documentation stays in sync with actual deployments
# Versions are read from values.yaml files using productVersion fields

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

# Check for required tools
if ! command -v python3 &> /dev/null; then
  echo "✗ Error: 'python3' not found. Please install it to continue."
  exit 1
fi

echo "Generating component documentation from values.yaml files..."

# Generate COMPONENTS.md and components.json using Python + yq
# This reads metadata from YAML and versions from values.yaml dynamically
python3 << 'PYTHON_EOF'
import yaml
import json
import subprocess
from datetime import datetime
from pathlib import Path

REPO_ROOT = Path(".")
METADATA_FILE = REPO_ROOT / "scripts" / "components-metadata.yaml"

def get_version_from_values(values_path, values_key):
    """Read a version from values.yaml using yq."""
    try:
        result = subprocess.run(
            ["yq", values_key, str(REPO_ROOT / values_path)],
            capture_output=True,
            text=True,
            timeout=5
        )
        version = result.stdout.strip().strip('"')
        if version and version != "null":
            return version
        return "UNKNOWN"
    except Exception as e:
        print(f"Warning: Could not read version from {values_path}: {e}", file=__import__('sys').stderr)
        return "UNKNOWN"

# Load metadata
with open(METADATA_FILE) as f:
    metadata = yaml.safe_load(f)

# Build components list with versions read from values.yaml
components_list = []
for comp_key, comp_meta in metadata.get("components", {}).items():
    # Format display name (title case with spaces)
    display_name = comp_meta.get("chart", comp_key).replace("-", " ").title()
    
    # Read version from values.yaml using yq
    version = get_version_from_values(
        comp_meta["values_path"],
        comp_meta["values_key"]
    )
    
    component = {
        "name": display_name,
        "key": comp_key,
        "version": version,
        "category": comp_meta["category"],
        "cncf_status": comp_meta["cncf_status"],
        "documentation": comp_meta["documentation"],
        "repository": comp_meta["repository"],
        "cncf_landscape": comp_meta["cncf_landscape"],
        "purpose": comp_meta["purpose"],
    }
    components_list.append(component)

# Sort by category, then name
components_list.sort(key=lambda x: (x["category"], x["name"]))

# Generate COMPONENTS.md
md_lines = [
    "# Aurora Platform Components",
    "",
    "This document lists all components deployed in the Aurora Platform with their versions, documentation references, and security/compliance information. All components are sourced from the Cloud Native Computing Foundation (CNCF) ecosystem to ensure compliance with supply chain integrity requirements (SA-12).",
    "",
    "**Note:** Cost is $0.00 for all components (open source). Highest data classification: Secret. All components are hosted on GC networks.",
    "",
    "---",
    "",
]

# Generate sections by category
current_category = None
for comp in components_list:
    if comp["category"] != current_category:
        current_category = comp["category"]
        md_lines.append("")
        md_lines.append(f"## {current_category} Components")
        md_lines.append("")
    
    md_lines.append(f"### {comp['name']}")
    md_lines.append(f"- **Version:** {comp['version']}")
    md_lines.append(f"- **CNCF Status:** {comp['cncf_status']}")
    
    if comp["cncf_landscape"] != "N/A":
        md_lines.append(f"- **CNCF Landscape:** [{comp['name']}]({comp['cncf_landscape']})")
    
    md_lines.append(f"- **Documentation:** [{comp['name']}]({comp['documentation']})")
    md_lines.append(f"- **Repository:** [{comp['repository'].split('/')[-1]}]({comp['repository']})")
    md_lines.append(f"- **Purpose:** {comp['purpose']}")
    md_lines.append("- **Cost:** $0.00 (open source)")
    md_lines.append("- **Data Classification:** Secret")
    md_lines.append("- **Hosted on GC Networks:** Yes")
    md_lines.append("")

# Add compliance notes
md_lines.extend([
    "---",
    "",
    "## Compliance Notes",
    "",
    "All components listed above are sourced from the Cloud Native Computing Foundation (CNCF) ecosystem:",
    "- **Graduated Projects:** Industry-standard, widely adopted, rigorous governance",
    "- **Incubating Projects:** Actively developed, under CNCF oversight, community-driven",
    "- **Sandbox Projects:** Early-stage, CNCF-managed, transparent development practices",
    "",
    "Each project undergoes:",
    "- Independent third-party vulnerability audits",
    "- Transparent governance and release processes",
    "- Active security maintenance and patching",
    "- Public vulnerability disclosure policies",
    "",
    "---",
    "",
    "## Export Metadata",
    "",
    "| Component | Version | Category | CNCF Status | Repository | Cost |",
    "|-----------|---------|----------|-------------|------------|------|",
])

for comp in components_list:
    md_lines.append(f"| {comp['name']} | {comp['version']} | {comp['category']} | {comp['cncf_status']} | [{comp['repository'].split('/')[-1]}]({comp['repository']}) | $0.00 |")

md_lines.append("")

with open(REPO_ROOT / "COMPONENTS.md", "w") as f:
    f.write("\n".join(md_lines))

# Generate components.json
json_data = {
    "platform": "Aurora Platform",
    "metadata": {
        "compliance_standard": "SA-12 Supply Chain Integrity",
        "generated": datetime.utcnow().isoformat() + "Z",
        "exported_for": "CCCS Review",
        "all_opensource": True,
        "data_classification": "Secret",
        "hosted_on_gc_networks": True,
        "version_sources": "Dynamically read from values.yaml files using productVersion fields",
    },
    "components": [
        {
            "name": comp["name"],
            "version": comp["version"],
            "category": comp["category"],
            "cncf_status": comp["cncf_status"],
            "cost": "$0.00",
            "cost_model": "opensource",
            "data_classification": "Secret",
            "hosted_on_gc_networks": True,
            "documentation": comp["documentation"],
            "repository": comp["repository"],
            "cncf_landscape": comp["cncf_landscape"],
            "purpose": comp["purpose"],
        }
        for comp in components_list
    ],
    "compliance_notes": {
        "cncf_sourcing": {
            "requirement": "All platform tools must be sourced from trusted CNCF ecosystem.",
            "approach": "All components are CNCF Graduated, Incubating, or Sandbox projects with transparent governance, independent audits, and active security maintenance.",
            "additional_hardening": "Core application workloads utilize secure, minimal Chainguard base images to eliminate unnecessary packages, shells, and package managers, reducing vulnerability footprint."
        }
    },
    "categories": {
        "Core": "Foundational platform components for networking, security, observability, and operations",
        "Application": "Components for CI/CD, service mesh, and application-level features",
        "Management": "Cluster-wide management and optimization components"
    },
    "cncf_status_definitions": {
        "Graduated": "Stable, production-ready, widely adopted by industry",
        "Incubating": "Actively developed, under CNCF governance, community-driven",
        "Sandbox": "Early-stage, CNCF-managed, transparent development practices"
    }
}

with open(REPO_ROOT / "components.json", "w") as f:
    json.dump(json_data, f, indent=2)

PYTHON_EOF

echo "✓ Generated COMPONENTS.md"
echo "✓ Generated components.json"
echo "✓ Component documentation auto-generation complete"
echo ""
echo "Version sources are dynamically read from:"
echo "  - stable/aurora-platform/charts/aurora-core/values.yaml"
echo "  - stable/aurora-platform/charts/aurora-app/values.yaml"
echo "  - stable/aurora-platform/charts/aurora-mgmt/values.yaml"
echo "  - stable/argocd-instance/values.yaml"

#!/bin/bash

# Helper script to easily add new workshop versions
# Usage: ./add-workshop-version.sh 2025.6.NYC "New York City" "NYC 2025.6"

echo "➕ Add New Workshop Version"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_future() { echo -e "${PURPLE}[NEW]${NC} $1"; }

# Check if parameters provided
if [ $# -lt 3 ]; then
    print_error "Usage: $0 <version> <city> <title> [protection_level]"
    echo ""
    echo "Examples:"
    echo "  $0 2025.6.NYC \"New York City\" \"NYC 2025.6\""
    echo "  $0 2025.7.CHI \"Chicago\" \"Chicago 2025.7\" FLEXIBLE"
    echo "  $0 2025.8.SEA \"Seattle\" \"Seattle 2025.8\" RESTRICTED"
    echo ""
    echo "Available protection levels:"
    echo "  • FLEXIBLE (default) - Full development freedom"
    echo "  • RESTRICTED - Warnings before changes"
    echo "  • PROTECTED - Cannot be modified"
    exit 1
fi

VERSION=$1
CITY=$2
TITLE=$3
PROTECTION=${4:-"FLEXIBLE"}

print_future "Adding new workshop version: $VERSION ($CITY)"

# Step 1: Create the new version
print_status "Creating Mike version $VERSION..."
mike deploy "$VERSION" --title "$TITLE"

if [ $? -ne 0 ]; then
    print_error "Failed to create version $VERSION"
    exit 1
fi

print_success "Version $VERSION created successfully"

# Step 2: Add to protection configuration
print_status "Adding protection configuration..."

# Convert version to config format (replace dots with underscores)
CONFIG_VERSION=$(echo "$VERSION" | sed 's/\./_/g')

cat >> mike-protection.conf << EOF

# $CITY Workshop - $VERSION
${CONFIG_VERSION}_PROTECTION="$PROTECTION"
${CONFIG_VERSION}_DESCRIPTION="$CITY workshop - $(date +'%B %Y')"

EOF

print_success "Protection configuration added for $VERSION"

# Step 3: Update safe operations script
print_status "Updating safe operations for $VERSION..."

# Add version pattern to mike-safe-operations.sh if not already present
CITY_CODE=$(echo "$VERSION" | grep -o '[A-Z][A-Z][A-Z]$')
if [ ! -z "$CITY_CODE" ]; then
    # Check if city code pattern already exists
    if ! grep -q "\"$CITY_CODE\"" mike-safe-operations.sh; then
        # Add city code to the pattern matching
        sed -i '' "s/\"2025\.\"\*\"\.SEA\")/\"2025.\"\*\"\.SEA\"|\"2025.\"\*\".$CITY_CODE\")/g" mike-safe-operations.sh
        print_success "Safe operations updated with $CITY_CODE pattern"
    fi
fi

# Step 4: Show current structure
print_status "Current Mike version structure:"
mike list

echo ""
print_success "🎉 New Workshop Version Added Successfully!"
echo ""
print_future "Version Details:"
echo "  📍 Version: $VERSION"
echo "  🏙️  City: $CITY"
echo "  📝 Title: $TITLE"
echo "  🛡️  Protection: $PROTECTION"
echo ""
print_status "Next steps for $CITY workshop:"
echo "  1. Customize content: Edit docs/ files for $CITY-specific content"
echo "  2. Create CSV data: Add data/${CITY,,}_lab_assignment.csv if needed"
echo "  3. Test locally: mike serve and check http://localhost:8001/$VERSION/"
echo "  4. Deploy updates: mike deploy $VERSION --title \"$TITLE\""
echo "  5. Make it latest: mike deploy $VERSION --update-aliases (when ready)"
echo ""
print_status "Access new version:"
echo "  🔗 Local: http://localhost:8001/$VERSION/"
echo "  🔗 GitHub Pages: https://mbalagot12.github.io/campus-workshop/$VERSION/ (after push)"
echo ""
print_success "Workshop version $VERSION ready for development! 🚀"

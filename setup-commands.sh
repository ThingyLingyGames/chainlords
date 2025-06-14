#!/usr/bin/env bash
# ChainLords Project Setup Commands
# Run these commands one by one or all at once

# First, ensure you have the right GitHub permissions
echo "First, run this to add project permissions:"
echo "gh auth refresh -h github.com -s project,read:project,write:org,admin:org"
echo ""
echo "Press Enter after authentication is complete..."
read

# Configuration
OWNER="ThingyLingyGames"
REPO="chainlords"
PROJECT_TITLE="ChainLords Development"

# Create the project
echo "Creating GitHub Project..."
PROJECT_JSON=$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json)
PROJECT_NUMBER=$(echo "$PROJECT_JSON" | jq -r '.number')
echo "Created project #$PROJECT_NUMBER"

# Create Status field with columns
gh project field-create $PROJECT_NUMBER \
    --owner "$OWNER" \
    --name "Status" \
    --data-type "SINGLE_SELECT" \
    --single-select-options "📋 Backlog,🎯 Sprint Ready,🚀 In Progress,👀 In Review,✅ Done"

# Create Story Points field
gh project field-create $PROJECT_NUMBER \
    --owner "$OWNER" \
    --name "Story Points" \
    --data-type "NUMBER"

# Create Priority field
gh project field-create $PROJECT_NUMBER \
    --owner "$OWNER" \
    --name "Priority" \
    --data-type "SINGLE_SELECT" \
    --single-select-options "🔴 Critical,🟠 High,🟡 Medium,🟢 Low"

# Create Sprint field
gh project field-create $PROJECT_NUMBER \
    --owner "$OWNER" \
    --name "Sprint" \
    --data-type "TEXT"

# Add all issues to the project
echo "Adding issues to project..."
ISSUES=$(gh issue list --repo "$OWNER/$REPO" --json number -q '.[].number')

for issue in $ISSUES; do
    echo "Adding issue #$issue to project..."
    gh project item-add $PROJECT_NUMBER \
        --owner "$OWNER" \
        --url "https://github.com/$OWNER/$REPO/issues/$issue"
done

# Set up initial issue states
echo "Setting up issue states..."

# Move epics to backlog
gh issue list --repo "$OWNER/$REPO" --label "epic" --json number -q '.[].number' | while read issue; do
    echo "Moving epic #$issue to Backlog"
    # Note: Setting field values requires the GraphQL API
done

# Move sprint-1 issues to Sprint Ready
gh issue list --repo "$OWNER/$REPO" --label "sprint-1" --json number -q '.[].number' | while read issue; do
    echo "Moving sprint 1 issue #$issue to Sprint Ready"
    # Note: Setting field values requires the GraphQL API
done

echo ""
echo "✨ Project setup complete!"
echo "View your project at: https://github.com/orgs/$OWNER/projects/$PROJECT_NUMBER"
echo ""
echo "Next steps:"
echo "1. Go to the project board"
echo "2. Manually drag issues to appropriate columns"
echo "3. Set story points for each issue"
echo "4. Start your sprint!"

# Alternative: Use the GitHub web interface
echo ""
echo "Alternative: Set up via web interface"
echo "1. Go to: https://github.com/orgs/$OWNER/projects/new"
echo "2. Select 'Board' template"
echo "3. Name it: $PROJECT_TITLE"
echo "4. Add the following columns:"
echo "   - 📋 Backlog"
echo "   - 🎯 Sprint Ready"
echo "   - 🚀 In Progress"
echo "   - 👀 In Review"
echo "   - ✅ Done"
echo "5. Add custom fields:"
echo "   - Story Points (Number)"
echo "   - Priority (Single Select: 🔴 Critical, 🟠 High, 🟡 Medium, 🟢 Low)"
echo "   - Sprint (Text)"
echo "6. Click 'Add items' and search for 'repo:$OWNER/$REPO' to add all issues"

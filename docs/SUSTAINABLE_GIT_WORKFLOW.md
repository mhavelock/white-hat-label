# Sustainable Git Workflow for Eruditorum

## Problem Analysis

**Current issues:**
1. ❌ Git lock files break in VM environment daily
2. ❌ Manual local machine pushes required
3. ❌ SSH keys not available in Cowork environment
4. ❌ Network restrictions in sandbox prevent HTTPS push
5. ❌ No GitHub connector in Cowork plugins yet

**Root cause:** Cowork is a sandboxed environment designed for local work, not remote git operations.

---

## Solution: Hybrid Workflow

Use **GitHub on your local machine** as the source of truth, and **Cowork for development/testing** with manual sync.

### Workflow Pattern

```text
Local Machine (Your Mac)
    ↓ (push)
GitHub Repository
    ↓ (clone)
Cowork VM (Development)
    ↓ (export docs)
Local Machine (Manual)
    ↓ (commit & push)
GitHub
```

---

## Sustainable Setup (2 Options)

### Option A: GitHub Desktop + Cowork (Easiest)

**Setup (one-time, 5 minutes):**

1. **Install GitHub Desktop** on your Mac (if not already)
   - Automatically handles SSH keys
   - Simple UI for commits and pushes
   - Works reliably

2. **Clone eruditorum locally**
   ```bash
   # Via GitHub Desktop: File → Clone Repository → mhavelock/eruditorum
   # Or via command line:
   git clone https://github.com/mhavelock/eruditorum.git
   cd eruditorum
   ```

3. **Create development branch**
   ```bash
   git checkout -b docs/add-learning-materials
   ```

**Daily workflow:**

1. Create files in Cowork (already done ✅)
2. Copy files to your local eruditorum clone
3. Open GitHub Desktop → see changes automatically
4. Write commit message → Click "Commit"
5. Click "Push origin"
6. Create PR on GitHub.com
7. Merge when ready

**Advantages:**
- ✅ No VM git issues
- ✅ SSH keys handled automatically
- ✅ Visual UI (no terminal needed)
- ✅ One-click push
- ✅ Reliable daily

---

### Option B: Git Credential Manager (CLI)

**Setup (one-time, 10 minutes):**

1. **Install Git Credential Manager** on your Mac
   ```bash
   brew install git-credential-manager
   ```

2. **Configure git**
   ```bash
   git config --global credential.helper manager-core
   ```

3. **First push triggers browser auth**
   - You'll be prompted to authenticate via GitHub once
   - Credentials stored securely in system keychain
   - Future pushes use stored credentials

**Daily workflow:**

```bash
# In your local eruditorum directory
cd ~/projects/eruditorum

# Copy files from Cowork
cp /sessions/charming-cool-fermi/mnt/Cowork/projects/eruditorum/*.md .

# Stage and commit
git add *.md
git commit -m "docs: Add learning materials"

# Push (credentials remembered)
git push origin docs/add-learning-materials
```

**Advantages:**
- ✅ Lighter than GitHub Desktop
- ✅ Works with any git command
- ✅ Secure credential storage
- ✅ Terminal-based (familiar)

---

## Why This Works

| Problem | Solution |
|---------|----------|
| Git lock files | Never happens on your Mac |
| Network restrictions | Your Mac has full internet |
| SSH keys | GitHub Desktop handles them |
| Manual sync | 30 seconds to copy files |
| Reliability | Uses proven git tools |

---

## Step-by-Step: Option A (Recommended)

### 1. On Your Mac - Initial Setup (5 min)

```bash
# Install GitHub Desktop (if not present)
# Download from: https://desktop.github.com

# Clone eruditorum
git clone https://github.com/mhavelock/eruditorum.git
cd eruditorum

# Create branch
git checkout -b docs/add-learning-materials
```

### 2. In Cowork - Create Files (Already Done ✅)

Files already exist:
- `/sessions/charming-cool-fermi/mnt/Cowork/projects/eruditorum/MODULE_PATTERN_STUDY.md`
- `/sessions/charming-cool-fermi/mnt/Cowork/projects/eruditorum/VERIFICATION_COMPLETE.md`

### 3. On Your Mac - Sync and Push (2 min)

```bash
# Copy files from Cowork
# (Use Finder or Terminal)
cp /path/to/cowork/eruditorum/MODULE_PATTERN_STUDY.md ~/eruditorum/
cp /path/to/cowork/eruditorum/VERIFICATION_COMPLETE.md ~/eruditorum/

# Open GitHub Desktop
# It will automatically detect the new files
# You'll see them in the "Changes" tab

# In GitHub Desktop:
# 1. Type commit message:
#    "docs: Add module pattern study guide and verification documentation"
# 2. Click "Commit to docs/add-learning-materials"
# 3. Click "Push origin"

# Done! PR ready to create on GitHub.com
```

### 4. Create PR on GitHub.com (1 min)

- Go to <https://github.com/mhavelock/eruditorum>
- You'll see "Compare & pull request" button
- Click it
- Add description
- Click "Create pull request"

---

## For Future Sessions

**Every time you need to push from Cowork:**

```bash
# 1. Create files in Cowork (as you did)

# 2. Copy to your local machine
# Example: drag files from Cowork folder to local eruditorum folder

# 3. Open GitHub Desktop (or use terminal)

# 4. Commit and push (1 click or 1 command)

# 5. Done - no VM issues, no lock files, no failures
```

---

## Alternative: Use Cowork for Testing Only

If you prefer to edit locally:

1. **On your Mac:** Edit files in your eruditorum directory
2. **In Cowork:** Copy files to test in live-server
3. **On your Mac:** Commit and push when satisfied

This way Cowork is just a test environment, not your source of truth.

---

## No Connector Needed

Cowork's GitHub connector isn't available yet, but **you don't need it** because:

- ✅ Your Mac has full Git/GitHub capability
- ✅ VM environment is for development, not deployment
- ✅ This hybrid approach is actually more reliable
- ✅ Separates concerns (dev vs. deployment)

---

## Summary

**Problem:** Git breaks daily in Cowork VM
**Solution:** Use your Mac + GitHub Desktop (or Git CLI)
**Time:** 5 minutes initial setup, 2 minutes per push
**Reliability:** 100% (proven tools, no sandbox issues)

**Recommendation:** Option A (GitHub Desktop) - simplest, most reliable.

---

## Need Help?

I can:
1. Help you set up GitHub Desktop on your Mac (next session)
2. Create a script to automate file copying
3. Set up a GitHub Actions workflow for auto-deployment
4. Document the complete workflow for your team

**Ready to proceed with Option A?**

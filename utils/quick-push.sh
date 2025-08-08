# --- SIMPLE SCRIPT TO SIMPLIFY PUSHING TO GIT --- #
#!/bin/bash
bash utils/fix-permissions.sh
git add .
git commit -m "$1" 
git push -u origin main
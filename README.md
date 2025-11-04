* Please keep in mind:
  - start docker first: ttps://github.com/dreammnck/QA-term-project1
  - install python
 
    
==== Step to run robot ===
1. CD to this path project
2. Create env (command: python3 -m venv ./xxx)
3. Activate env:  (command: source ./xxx/bin/activate)
4. Install lib: (command: pip3 install -r requirements.txt)
5. run robot command:  robot -L TRACE -t"TC_003*" testcases/

Result if everything OK:

<img width="860" height="319" alt="Screenshot 2568-11-05 at 00 11 44" src="https://github.com/user-attachments/assets/5f4fb9aa-2f77-4e60-8c30-b4018ca6c71a" />


# ⚠️ Description 
This script is a reporting tool that analyzes user activity from a specified log file (default is /var/log/wtmp) and generates a report showing active users with details on their login times, number of logins, and total usage hours.

Here is a brief overview of what the script does:
1. It reads the log file specified by the user or defaults to /var/log/wtmp.
2. Extracts user activity data from the log file using the `last` command.
3. Processes the user data to calculate total usage hours, number of logins, and the first login time.
4. Prints a formatted report showing active users sorted by total usage hours.

```bash
./active_users.sh /var/log/wtmp
``` 
Make sure you have the necessary permissions to read the log file. Additionally, review the script and ensure it meets your requirements before running it.
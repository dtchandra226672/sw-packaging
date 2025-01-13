import re

# Define the regex pattern
pattern = r'<h2 id="version[^"]+">Version ([\d\.]+)'

# Function to read the file and find matches
def extract_versions_from_file(file_path):
    try:
        with open(file_path, 'r') as file:
            content = file.read()
            matches = re.findall(pattern, content)
            
            if matches:
                print("Found version numbers:")
                for match in matches:
                    print(match)
            else:
                print("No version numbers found.")
                
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

# File path input
file_path = input("Enter the path of the text file: ")
extract_versions_from_file(file_path)
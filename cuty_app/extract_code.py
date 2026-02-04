import os

def extract_project_code(output_file='project_full_context.txt'):
    root_dir = os.getcwd()
    lib_dir = os.path.join(root_dir, 'lib')
    pubspec_path = os.path.join(root_dir, 'pubspec.yaml')
    
    print(f"Starting extraction from {root_dir}...")
    
    count = 0
    with open(output_file, 'w', encoding='utf-8') as outfile:
        # 1. Add pubspec.yaml
        if os.path.exists(pubspec_path):
            print("Adding pubspec.yaml")
            outfile.write(f'=== pubspec.yaml ===\n')
            try:
                with open(pubspec_path, 'r', encoding='utf-8') as infile:
                    outfile.write(infile.read())
            except Exception as e:
                outfile.write(f'Error reading file: {e}')
            outfile.write('\n\n')
            count += 1
        
        # 2. Walk through lib directory
        if os.path.exists(lib_dir):
            for root, dirs, files in os.walk(lib_dir):
                # Exclude 'generated' directory
                if 'generated' in dirs:
                    dirs.remove('generated')
                
                for file in files:
                    if file.endswith('.dart') and not (file.endswith('.g.dart') or file.endswith('.freezed.dart')):
                        file_path = os.path.join(root, file)
                        relative_path = os.path.relpath(file_path, root_dir)
                        
                        outfile.write(f'=== {relative_path} ===\n')
                        try:
                            with open(file_path, 'r', encoding='utf-8') as infile:
                                outfile.write(infile.read())
                            count += 1
                        except Exception as e:
                             outfile.write(f'Error reading file: {e}')
                        outfile.write('\n\n')
        else:
            print("Warning: 'lib' directory not found.")

    print(f"Extraction complete. {count} files saved to {output_file}")

if __name__ == '__main__':
    extract_project_code()

import os

assets_dir = "assets"

for root, dirs, files in os.walk(assets_dir, topdown=False):
    # Переименование файлов
    for file_name in files:
        new_name = file_name.replace(" ", "_")
        if new_name != file_name:
            old_path = os.path.join(root, file_name)
            new_path = os.path.join(root, new_name)
            os.rename(old_path, new_path)
            print(f'Renamed file: "{old_path}" -> "{new_path}"')

    # Переименование папок
    for dir_name in dirs:
        new_name = dir_name.replace(" ", "_")
        if new_name != dir_name:
            old_path = os.path.join(root, dir_name)
            new_path = os.path.join(root, new_name)
            os.rename(old_path, new_path)
            print(f'Renamed folder: "{old_path}" -> "{new_path}"')

print("Done!")

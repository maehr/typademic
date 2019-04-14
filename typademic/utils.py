import os

from sh import pandoc


def sh_pandoc(input_files, output_filename, cwd_path):
    pandoc(
        " ".join(input_files),
        '--output',
        output_filename,
        '--from',
        'markdown+ascii_identifiers+tex_math_single_backslash+raw_tex+table_captions+yaml_metadata_block+autolink_bare_uris',
        '--pdf-engine=xelatex',
        '--filter',
        'pandoc-citeproc',
        '--resource-path=' + cwd_path,
        '--standalone',
        _cwd=cwd_path)


def remove_all_files_recursively(path):
    try:
        for root, dirs, files in os.walk(path, topdown=False):
            for name in files:
                os.remove(os.path.join(root, name))
            for name in dirs:
                os.remove(os.path.join(root, name))
        return None
    except Exception as e:
        return e

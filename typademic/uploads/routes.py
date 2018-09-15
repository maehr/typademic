import os
import uuid

from flask import session, render_template, request, send_file, redirect, url_for, current_app
from sh import pandoc

from typademic.app import limiter
from typademic.uploads import blueprint
from typademic.utils import remove_all_files_recursively


@blueprint.route('/', methods=['GET'])
def index():
    if 'uid' not in session:
        return render_template('index.html',
                               files=None,
                               error='')
    else:
        session_path = os.path.join(current_app.config['UPLOADED_PATH'], session['uid'])
        files = os.listdir(session_path)
        return render_template('index.html',
                               files=files,
                               error='')


@blueprint.route('/', methods=['POST'])
def upload():
    if 'uid' not in session:
        try:
            uid = uuid.uuid4().hex
            session['uid'] = uid
            session_path = os.path.join(current_app.config['UPLOADED_PATH'], session['uid'])
            # ensure the upload folder exists
            os.mkdir(session_path)
        except Exception as e:
            return render_template('index.html',
                                   files=None,
                                   error=str(e))
    session_path = os.path.join(current_app.config['UPLOADED_PATH'], session['uid'])

    try:
        f = request.files.get('file')
        f.save(os.path.join(session_path, f.filename))
        files = os.listdir(session_path)
        return render_template('index.html',
                               files=files,
                               error='')
    except Exception as e:
        files = os.listdir(session_path)
        return render_template('index.html',
                               files=files,
                               error=str(e))


@blueprint.route('/clear', methods=['GET'])
def clear():
    if 'uid' not in session:
        return render_template('index.html',
                                   files=None,
                                   error=None,
                                   info='Nothing to remove.')
    else:
        session_path = os.path.join(current_app.config['UPLOADED_PATH'], session['uid'])
        try:
            remove_all_files_recursively(session_path)
            return render_template('index.html',
                                   files=None,
                                   error=None,
                                   info='All files are successfully removed.')
        except Exception as e:
            files = os.listdir(session_path)
            return render_template('index.html',
                                   files=files,
                                   error=str(e))


@blueprint.route('/clear_all/<key>', methods=['GET'])
@limiter.limit("2 per day")
def clear_all(key):
    if key is current_app.config['SECRET_KEY']:
        try:
            remove_all_files_recursively(os.path.abspath(current_app.config['UPLOADED_PATH']))
            return render_template('index.html',
                                   files=None,
                                   error=None,
                                   info='All files are successfully removed.')
        except Exception as e:
            return render_template('index.html',
                                   files=None,
                                   error=str(e))
    else:
        return redirect(url_for('uploads.index'))


@blueprint.route('/pdf', methods=['GET'])
def pdf():
    if 'uid' not in session:
        return redirect(url_for('uploads.index'))
    else:
        session_path = os.path.join(current_app.config['UPLOADED_PATH'], session['uid'])
        return render(session_path=session_path, output_format='pdf')


@blueprint.route('/docx', methods=['GET'])
def docx():
    if 'uid' not in session:
        return redirect(url_for('uploads.index'))
    else:
        session_path = os.path.join(current_app.config['UPLOADED_PATH'], session['uid'])
        return render(session_path=session_path, output_format='docx')


def render(session_path, output_format='pdf'):
    files = os.listdir(session_path)
    output_filename = 'typademic.' + output_format
    try:
        md_files = ''
        for file in files:
            # Serve from cache
            if file.endswith(output_filename):
                return send_file(os.path.join(session_path, output_filename),
                                 attachment_filename=output_filename)
            # Extract md file(s)
            if file.endswith('.md'):
                md_files = md_files + ' ' + file
        if md_files is '':
            return render_template('index.html',
                                   files=files,
                                   error='No Markdown file was uploaded. Please reset and try again.')
        pandoc(md_files.strip(),
               '--output',
               output_filename,
               '--from',
               'markdown+ascii_identifiers+tex_math_single_backslash+raw_tex+table_captions+yaml_metadata_block+autolink_bare_uris',
               '--latex-engine=xelatex',
               # FIXME Pandoc 2.2.3 fix
               # '--pdf-engine=xelatex',
               '--filter',
               'pandoc-citeproc',
               '--standalone',
               _cwd=session_path)
        return send_file(os.path.join(session_path, output_filename),
                         attachment_filename=output_filename)
    except Exception as e:
        return render_template('index.html',
                               files=files,
                               error=str(e))

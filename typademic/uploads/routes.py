# TODO remove logger
import logging
import os
import uuid

from flask import session, render_template, request, send_file, redirect, url_for, current_app
from sh import pandoc

from typademic import limiter
from typademic.uploads import blueprint

# TODO remove logger
log = logging.getLogger('typademic')


def uploaded_files():
    try:
        return os.listdir(os.path.join(current_app.config['UPLOADED_PATH'], session['uid']))
    except Exception:
        return []


@blueprint.route('/')
@blueprint.route('/index')
def index():
    if 'uid' not in session:
        return render_template('index.html',
                               files=None,
                               error='')
    else:
        return render_template('index.html',
                               files=uploaded_files(),
                               error='')


@blueprint.route('/upload', methods=['POST'])
def upload():
    if 'uid' not in session:
        try:
            uid = uuid.uuid4().hex
            session['uid'] = uid
            session_upload_path = os.path.join(current_app.config['UPLOADED_PATH'], uid)
            # ensure the upload folder exists
            os.mkdir(session_upload_path)
        except Exception as e:
            return render_template('index.html',
                                   files=uploaded_files(),
                                   error=str(e))

    try:
        # TODO remove logger
        log.info(request.form)
        log.info(request.files)
        f = request.files.get('file')
        f.save(os.path.join(current_app.config['UPLOADED_PATH'], session['uid'], f.filename))
        return render_template('index.html',
                               files=uploaded_files(),
                               error='')
    except Exception as e:
        return render_template('index.html',
                               files=uploaded_files(),
                               error=str(e))


@blueprint.route('/clear', methods=['GET'])
def clear():
    try:
        for root, dirs, files in os.walk(os.path.join(current_app.config['UPLOADED_PATH'], session['uid']),
                                         topdown=False):
            for name in files:
                os.remove(os.path.join(root, name))
            for name in dirs:
                os.remove(os.path.join(root, name))
        return redirect(url_for('upload'))
    except Exception as e:
        return render_template('index.html',
                               files=uploaded_files(),
                               error=str(e))


@blueprint.route('/clear_all/<key>', methods=['GET'])
@limiter.limit("1 per day")
def clear_all(key):
    if key is current_app.config['SECRET_KEY']:
        try:
            for root, dirs, files in os.walk(os.path.abspath(current_app.config['UPLOADED_PATH']), topdown=False):
                for name in files:
                    os.remove(os.path.join(root, name))
                for name in dirs:
                    os.remove(os.path.join(root, name))
            return render_template('index.html',
                                   files=uploaded_files(),
                                   error='All files are successfully removed.')
        except Exception as e:
            return render_template('index.html',
                                   files=uploaded_files(),
                                   error=str(e))
    else:
        return redirect(url_for('upload'))


@blueprint.route('/render/<output_format>', methods=['GET'])
def render(output_format):
    if output_format not in ['docx', 'pdf']:
        return redirect(url_for('upload'))
    output_filename = 'typademic.' + output_format
    files = uploaded_files()
    try:
        md_files = ''
        for file in files:
            # Serve from cache
            if file.endswith(output_filename):
                return send_file(os.path.join(app.config['UPLOADED_PATH'], session['uid'], output_filename),
                                 attachment_filename=output_filename)
            # Extract md file(s)
            if file.endswith('.md'):
                md_files = md_files + ' ' + file
        if md_files is '':
            return render_template('index.html',
                                   files=files,
                                   error='No Markdown file was uploaded. Please reset and try again.')
        cwd = os.path.join(app.config['UPLOADED_PATH'], session['uid'])
        pandoc(md_files.strip(),
               '--output',
               output_filename,
               '--from',
               'markdown+ascii_identifiers+tex_math_single_backslash+raw_tex+table_captions+yaml_metadata_block+autolink_bare_uris',
               '--latex-engine=xelatex',
               # Pandoc 2.2.3 fix
               # '--pdf-engine=xelatex',
               '--filter',
               'pandoc-citeproc',
               '--standalone',
               _cwd=cwd)
        return send_file(os.path.join(app.config['UPLOADED_PATH'], session['uid'], output_filename),
                         attachment_filename=output_filename)
    except Exception as e:
        return render_template('index.html',
                               files=files,
                               error=str(e))

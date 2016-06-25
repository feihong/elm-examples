import os
import subprocess

from invoke import task
from jingtai import Site
from jingtai.transformers import SourceFileTransformer, register_transformer


site = Site('/elm-examples/')


@task
def serve(ctx):
    site.watch('site')
    site.watch('templates')
    site.serve(port=8000)


@task
def serve_build(ctx):
    site.serve_build(port=8000)


@task
def build(ctx):
    site.build()


@task
def clean(ctx):
    site.clean()


@task
def publish(ctx):
    site.publish()


@register_transformer
class ElmTransformer(SourceFileTransformer):
    input_ext = '.elm'
    output_ext = '.js'
    mime_type = 'text/javascript'

    def transform(self, src):
        dest_dir = src.parent
        self.build(src, dest_dir)
        return self.get_dest_file(src, dest_dir).read_text()

    def build(self, src, dest_dir):
        cmd = [
            'elm-make', str(src),
            '--yes',
            '--output', str(self.get_dest_file(src, dest_dir))
        ]
        return subprocess.call(cmd, cwd=str(src.parent))


NEW_PAGE_TEMPLATE = u"""\
title: %s

===

-inherit base.plim

#content
    Here is some content
"""


@task
def new_page(ctx, title, path):
    from jingtai.compat import Path
    new_file = Path('site') / path
    if new_file.suffix == '':
        new_file = new_file / 'index.plim'
    if not new_file.parent.exists():
        new_file.parent.mkdir(parents=True)
    with new_file.open('w') as fp:
        fp.write(NEW_PAGE_TEMPLATE % title)

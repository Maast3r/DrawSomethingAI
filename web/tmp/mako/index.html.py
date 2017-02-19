# -*- coding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
STOP_RENDERING = runtime.STOP_RENDERING
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 10
_modified_time = 1487543955.5665197
_enable_loop = True
_template_filename = 'views/index.html'
_template_uri = 'index.html'
_source_encoding = 'utf-8'
_exports = []


def render_body(context,**pageargs):
    __M_caller = context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        __M_writer = context.writer()
        __M_writer('<!DOCTYPE html>\r\n<html>\r\n  <head>\r\n    <title> Julia Draw Something </title>\r\n    <script src="/js/jquery-3.1.0.min.js"></script>\r\n    <script src="/js/index.js"></script>\r\n  </head>\r\n  <body>\r\n    <h1> Julia Draw Something! </h1>\r\n    <form enctype="multipart/form-data" action="/upload" method="post">\r\n      File: <input type="file" name="file1" />\r\n      <br />\r\n      <br />\r\n      <input type="submit" value="upload" />\r\n    </form>\r\n  </body>\r\n</html>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


"""
__M_BEGIN_METADATA
{"filename": "views/index.html", "line_map": {"16": 0, "27": 21, "21": 1}, "source_encoding": "utf-8", "uri": "index.html"}
__M_END_METADATA
"""

import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.websocket
import tornado.options, os.path, random, string
from tornado import gen
from tornado.queues import Queue

from mako import exceptions
from mako.template import Template
from mako.lookup import TemplateLookup

import numpy as np
import tensorflow as tf

import os, sys, time

config = tf.ConfigProto()
config.gpu_options.allow_growth = True
sess= tf.Session(config=config)

W = tf.Variable(tf.zeros([784, 10]), name="W")
b = tf.Variable(tf.zeros([10]), name="b")
y = tf.nn.softmax(tf.matmul(x, W) + b)
# saver = tf.train.Saver([W,b])
# saver.restore(sess, "models/something")

root = os.path.join(os.path.dirname(__file__), ".")
lookup = TemplateLookup(directories=[os.path.join(root, 'views')],
		input_encoding='utf-8',
		output_encoding='utf-8',
		default_filters=['decode.utf8'],
		module_directory=os.path.join(root, 'tmp/mako'))

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write(renderTemplate("index.html"))

class UploadHandler(tornado.web.RequestHandler):
    def post(self):
        file1 = self.request.files['file1'][0]
        original_fname = file1['filename']

        output_file = open("uploads/" + original_fname, 'wb')
        output_file.write(file1['body'])

        # sess.run(y, feed_dict={x: input, keep_prob: 1.0}).flatten().tolist()
        self.finish("file " + original_fname + " is uploaded")

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
        (r"/upload", UploadHandler),
        (r"/css/(.*)", tornado.web.StaticFileHandler,{'path': os.path.join(root, 'css')}),
		(r"/js/(.*)", tornado.web.StaticFileHandler,{'path': os.path.join(root, 'js')}),
		(r"/upload/(.*)", tornado.web.StaticFileHandler,{'path': os.path.join(root, 'js')}),
		(r"/models/(.*)", tornado.web.StaticFileHandler,{'path': os.path.join(root, 'js')}),
    ])
    
def renderTemplate(templateName, **kwargs):
	template = lookup.get_template(templateName)
	args = []
	try:
		return template.render(*args, **kwargs)
	except Exception as e:
		print(e)

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

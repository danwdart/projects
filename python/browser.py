#!/usr/bin/env python
from gtk import Window, main, main_quit, ScrolledWindow
from webkit import WebView 

class Dan:
	def __init__(self):
		self.url = "http://www.bibud.com"
		self.setupWindow()
		self.setupBrowser()
		main()
	def setupWindow(self):
		self.window_title = "Bibud"
		self.window = Window()
		self.window.show()
		self.window.connect("destroy-event", self.browser_quit)
		self.window.resize(1024,768)
		self.window.set_title(self.window_title)
	def setupBrowser(self):
		self.browser = WebView()
		self.browser.show()
		self.browser.open(self.url)
		self.scroller = ScrolledWindow()
		self.scroller.add(self.browser)
		self.window.add(self.scroller)
		self.browser.connect("title-changed", self.title_changed)
		self.scroller.show()
	def eTitleChanged(self, webview, frame, title):
		self.window.set_title(title)
	def eQuit(self):
		main_quit()
program = Dan()

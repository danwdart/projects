import gtk
import webkit
window = gtk.Window()
window.show()

window.resize(200,200)
window.set_title("Bibud")

go = gtk.Button("Go!")

hbox = gtk.HBox()

text = gtk.Entry()

hbox.pack_start(text)

hbox.pack_start(go)

window.add(hbox)

browser = webkit.WebView()
window.add(browser)
browser.show()
browser.open("http://www.example.com")

scroller = gtk.ScrolledWindow()
scroller.add(browser)
window.add(scroller)
scroller.show()

window.show_all()


window.remove(scroller)
vbox = gtk.VBox()
window.add(vbox)
vbox.pack_start(hbox)
vbox.show()
vbox.pack_start(scroller)
print text.get_text()
def goclicked(btn):
	browser.open(text.get_text())
go.connect("clicked",goclicked)
vbox.remove(scroller)
vbox.remove(hbox)
vbox.pack_start(hbox,False)
vbox.pack_start(scroller)
def title_changed(webview, frame, title):
	window.set_title(title)
browser.connect("title-changed", title_changed)
progress = gtk.ProgressBar()
vbox.pack_start(progress, False)
progress.show()
def load_progress_changed(webview,amount):
	progress.set_fraction(amount / 100.0)
browser.connect("load-progress-changed",load_progress_changed)
def load_started(webview, frame):
	progress.set_visible(True)
def load_finished(webview, frame):
	progress.set_visible(False)
browser.connect("load-started", load_started)
browser.connect("load-finished", load_finished)
refresh = gtk.Button(stock = gtk.STOCK_REFRESH)
hbox.pack_start(refresh)
refresh.show()
def refresh_clicked(btn):
	browser.reload()
refresh.connect("clicked", refresh_clicked)


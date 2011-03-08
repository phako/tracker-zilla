trackerzilla: main.vala abstract-info.vala linked-info.vala linking-info.vala main-window.vala
	valac -o trackerzilla main.vala abstract-info.vala linked-info.vala linking-info.vala main-window.vala --pkg tracker-sparql-0.10 --pkg webkitgtk-3.0 --pkg gee-1.0 --pkg gtk+-3.0

For Paracortical Initiative, 2025, Diogo "Theklo" Duarte

Other projects:
- [Bluesky for news on any progress I've done](https://bsky.app/profile/diogo-duarte.bsky.social)
- [Itchi.io for my most stable playable projects](https://diogo-duarte.itch.io/)
- [The Github for source codes and portfolio](https://github.com/Theklo-Teal)
- [Ko-fi is where I'll accept donations](https://ko-fi.com/paracortical)

# DESCRIPTION
A window displaying an interactive graphical plot for the Godot Engine.

# INSTALLATION
Depends on DualSlider, which can be found here: https://github.com/Theklo-Teal/Godot_Dual_Slider

This isn't technically a Godot Plugin, it doesn't use the special Plugin features of the Editor, so don't put it inside the "addon" folder. The folder of the tool can be anywhere else you want, though, but I suggest having it in a "modules" folder.

To add a plot node to your project, you should instantiate the scene «plotter.tscn».

# USAGE
First you can set if you intend the plot to be modified by a user with the «editable» variable. If so, clicking with the right mouse button on a plot while the project is executing, will add sample points to the plot.You can set the «sample_clearance» which is how close together the samples can be. Clicking on the plot inside the clearance of an existing sample will just change the sample coordinate, rather than creating a new one.

The middle mouse button can be held to pan the view, but it's more controllable to use the scrolling sliders which can also be used for zooming on a section of the plot range. The left mouse button can click on sample of the plot and this will emit the «selected_sample» signal you may choose to connect that informs the index in the list of samples in the plot.

Just hovering the mouse on the samples will display the coordinates, which can be decorated with a suffix or a prefix. For example coordinate Vector2(4, 10) could be displayed as "Day 4, 10€". The vertical and horizontal axis drawn on the plot to indicate origin can also be independently titled, like "Days of Year" and "Cost".

To add coordinates to a non-editable plot, or just set up initial plot, you use the function «set_plot()» which takes the following arguments:
	«data» is a list of coordinates for the samples.
	«info» is an optional list of replacement values when displaying on mouse hover. So you could show different things on mouse hover but use another function for the drawn plot, for example if the plot is logarithmic or has different value units.
	«id» provides addressing values for the samples which are independent of the order sorting the samples, because the script often re-sorts the samples whenever something is changed.

Setting a plot will completely redraw the whole plot and adjust the pan and zoom ranges automatically.

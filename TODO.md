# DXRuby APIs

## module Input

- [x] x - TODO: pad support
- [x] y - TODO: pad support
- [x] key_down?
- [x] key_push?
- [x] key_release?
- [ ] pad_down?
- [ ] pad_push?
- [ ] pad_release?
- [ ] set_repeat
- [ ] set_key_repeat
- [ ] set_pad_repeat
- [ ] set_config
- [x] mouse_x
- [x] mouse_y
- [x] mouse_pos_x
- [x] mouse_pos_y
- [ ] set_mouse_pos
- [x] mouse_down?
- [x] mouse_push?
- [x] mouse_release?
- [ ] mouse_wheel_pos
- [ ] mouse_wheel_pos=
- [ ] mouse_enable=
- [ ] keys
- [ ] pads
- [ ] requested_close?
- [ ] update
- [ ] pad_num
- [ ] pad_axis
- [ ] pad_lstick
- [ ] pad_rstick
- [ ] pad_pov
- [ ] pad_lx
- [ ] pad_ly
- [ ] pad_rx
- [ ] pad_ry
- [ ] pad_pov_x
- [ ] pad_pov_y
- [ ] set_cursor

## module Window

- [x] loop
- [x] draw
- [ ] draw_scale
- [ ] draw_rot
- [ ] draw_alpha
- [ ] draw_add
- [ ] draw_sub
- [ ] draw_shader
- [ ] draw_ex
- [ ] draw_font - partially
- [ ] draw_font_ex
- [ ] draw_morph
- [ ] draw_tile
- [x] draw_pixel
- [x] draw_line
- [x] draw_box
- [x] draw_box_fill
- [x] draw_circle
- [x] draw_circle_fill
- [ ] ox
- [ ] ox=
- [ ] oy
- [ ] oy=
- [ ] get_screen_shot
- [ ] get_load
- [ ] open_filename
- [ ] save_filename
- [ ] folder_dialog
- [ ] x
- [ ] x=
- [ ] y
- [ ] y=
- [ ] width
- [ ] width=
- [ ] height
- [ ] height=
- [ ] caption
- [ ] caption=
- [ ] scale
- [ ] scale=
- [ ] windowed?
- [ ] windowed=
- [ ] full_screen?
- [ ] full_screen=
- [x] real_fps
- [x] fps
- [x] fps=
- [ ] frameskip?
- [ ] frameskip=
- [x] bgcolor
- [x] bgcolor=
- [ ] resize
- [ ] active?
- [ ] running_time
- [ ] get_screen_modes
- [ ] get_current_modes
- [ ] discard
- [ ] decide
- [ ] before_call
- [ ] after_call

These methods will not be supported (does not make sense in the browser or marked as obsolete).

- create
- close
- created?
- closed?
- update
- sync
- load_icon
- hWnd
- min_filter
- min_filter=
- mag_filter
- mag_filter=

## class Font

- [ ] new - partially
- [ ] install
- [x] default
- [x] default=
- [ ] dispose
- [ ] disposed?
- [ ] get_width
- [x] size
- [x] fontname
- [ ] name
- [ ] italic
- [ ] weight
- [ ] auto_fitting
- [ ] info

## class Image

- [ ] new
- [ ] load
- [ ] load_tiles
- [ ] create_from_array
- [ ] load_from_file_in_memory
- [ ] perlin_noise
- [ ] octave_perlin_noise
- [ ] custom_perlin_noise
- [ ] perlin_seed
- [ ] dispose
- [ ] delayed_dispose
- [ ] disposed?
- [x] `[]`
- [x] `[]=`
- [x] compare
- [x] line
- [x] box
- [x] box_fill
- [x] circle
- [x] circle_fill
- [x] triangle
- [x] triangle_fill
- [x] fill
- [x] clear
- [ ] copy_rect
- [ ] draw
- [ ] draw_font - partially
- [ ] draw_font_ex
- [ ] save
- [x] slice
- [x] slice_tiles
- [ ] dup
- [ ] clone
- [ ] set_color_key
- [x] width
- [x] height
- [ ] flush
- [ ] effect_image_font
- [ ] change_hls

## class RenderTarget
## class Shader
## class Shader::Core
## class Sound

- [ ] new
- [ ] load_from_memory
- [ ] dispose
- [ ] disposed?
- [x] play
- [ ] start=
- [ ] loop_start=
- [ ] loop_end=
- [ ] loop_count=
- [x] stop
- [ ] set_volume
- [ ] pan
- [ ] pan=
- [ ] frequency
- [ ] frequency=

## class SoundEffect

- [x] new
- [ ] disposed?
- [ ] add
- [x] play
- [x] stop
- [ ] save

## class Sprite

- [ ] new
- [ ] check
- [x] update
- [x] draw
- [x] clean
- [x] draw
- [x] `===`
- [x] check
- [x] x
- [x] x=
- [x] y
- [x] y=
- [x] z
- [x] z=
- [ ] angle
- [ ] angle=
- [ ] scale_x
- [ ] scale_x=
- [ ] scale_y
- [ ] scale_y=
- [ ] center_x
- [ ] center_x=
- [ ] center_y
- [ ] center_y=
- [ ] alpha
- [ ] alpha=
- [ ] blend
- [ ] blend=
- [ ] shader
- [ ] shader=
- [x] image
- [x] image=
- [ ] target
- [ ] target=
- [x] collision
- [x] collision=
- [x] collision_enable
- [x] collision_enable=
- [ ] collision_sync
- [ ] collision_sync=
- [x] visible
- [x] visible=
- [x] vanish
- [x] vanished?
- [ ] param_hash
- [ ] offset_sync
- [ ] offset_sync=

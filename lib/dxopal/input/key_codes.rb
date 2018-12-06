module DXOpal
  module Input
    # List of key codes (event.code)
    # https://developer.mozilla.org/ja/docs/Web/API/KeyboardEvent
    module KeyCodes
      # TODO: add more keycodes (pull request welcome)
      # especially keypads and us-keyboards

      K_ESCAPE = 'Escape'
      K_1 = 'Digit1'
      K_2 = 'Digit2'
      K_3 = 'Digit3'
      K_4 = 'Digit4'
      K_5 = 'Digit5'
      K_6 = 'Digit6'
      K_7 = 'Digit7'
      K_8 = 'Digit8'
      K_9 = 'Digit9'
      K_0 = 'Digit0'
      K_MINUS = 'Minus'
      K_EQUALS = 'Equal'
      K_BACK = 'Backspace'
      K_TAB = 'Tab'
      K_Q = 'KeyQ'
      K_W = 'KeyW'
      K_E = 'KeyE'
      K_R = 'KeyR'
      K_T = 'KeyT'
      K_Y = 'KeyY'
      K_U = 'KeyU'
      K_I = 'KeyI'
      K_O = 'KeyO'
      K_P = 'KeyP'
      K_LBRACKET = 'BracketLeft'
      K_RBRACKET = 'BracketRight'
      K_RETURN = 'Enter'
      K_ENTER = 'Enter'  # Alias; not in DXRuby
      K_LCONTROL = 'ControlLeft'
      K_A = 'KeyA'
      K_S = 'KeyS'
      K_D = 'KeyD'
      K_F = 'KeyF'
      K_G = 'KeyG'
      K_H = 'KeyH'
      K_J = 'KeyJ'
      K_K = 'KeyK'
      K_L = 'KeyL'
      K_SEMICOLON = 'Semicolon'
      K_APOSTROPHE = 'Quote'  # '
      #K_GRAVE = "`"
      K_LSHIFT = 'ShiftLeft'
      K_BACKSLASH = 'BackSlash'  # Note: different to K_YEN
      K_Z = 'KeyZ'
      K_X = 'KeyX'
      K_C = 'KeyC'
      K_V = 'KeyV'
      K_B = 'KeyB'
      K_N = 'KeyN'
      K_M = 'KeyM'
      K_COMMA = 'Comma'
      K_PERIOD = 'Period'
      K_SLASH = 'Slash'
      K_RSHIFT = 'ShiftRight'
      #K_MULTIPLY = "*"
      #K_LMENU Alt
      K_SPACE = 'Space'
      #K_CAPITAL
      K_F1 = 112
      K_F2 = 113
      K_F3 = 114
      K_F4 = 115
      K_F5 = 116
      K_F6 = 117
      K_F7 = 118
      K_F8 = 119
      K_F9 = 120
      K_F10 = 121
      #K_NUMLOCK = "NumLock"
      #K_SCROLL = "ScrollLock"
      #K_NUMPAD7 7 *3
      #K_NUMPAD8 8 *3
      #K_NUMPAD9 9 *3
      #K_SUBTRACT  - *3
      #K_NUMPAD4 4 *3
      #K_NUMPAD5 5 *3
      #K_NUMPAD6 6 *3
      #K_ADD + *3
      #K_NUMPAD1 1 *3
      #K_NUMPAD2 2 *3
      #K_NUMPAD3 3 *3
      #K_NUMPAD0 0 *3
      #K_DECIMAL . *3
      #K_OEM_102 
      K_F11 = 122
      K_F12 = 123
      K_F13 = 124
      K_F14 = 125
      K_F15 = 126
      #K_KANA 
      #K_ABNT_C1 
      #K_CONVERT 
      #K_NOCONVERT
      K_YEN = 'IntlYen'
      #K_ABNT_C2 
      #K_NUMPADEQUALS  = *3 *1
      #K_PREVTRACK
      #K_AT
      K_COLON = 'Colon'
      K_UNDERLINE = 'IntlRo'   # _
      #K_KANJI 
      #K_STOP
      #K_AX
      #K_UNLABELED
      #K_NEXTTRACK
      #K_NUMPADENTER Enter *3
      K_RCONTROL = 'ControlRight'
      #K_MUTE
      #K_CALCULATOR
      #K_PLAYPAUSE
      #K_MEDIASTOP
      #K_VOLUMEDOWN
      #K_VOLUMEUP
      #K_WEBHOME
      #K_NUMPADCOMMA , *3 *1
      #K_DIVIDE  / *3
      #K_SYSRQ
      #K_RMENU Alt
      #K_PAUSE = "Pause"
      #K_HOME "Home"
      K_UP = 'ArrowUp'
      #K_PRIOR
      K_LEFT = 'ArrowLeft'
      K_RIGHT = 'ArrowRight'
      #K_END = "End"
      K_DOWN = 'ArrowDown'
      #K_NEXT
      #K_INSERT = "Insert"
      #K_DELETE = "Delete"
      #K_LWIN  Windows
      #K_RWIN  Windows
      #K_APPS
      #K_POWER
      #K_SLEEP
      #K_WAKE
      #K_WEBSEARCH
      #K_WEBFAVORITES
      #K_WEBREFRESH
      #K_WEBSTOP
      #K_WEBFORWARD
      #K_WEBBACK
      #K_MYCOMPUTER
      #K_MAIL
      #K_MEDIASELECT
      K_BACKSPACE = 'Backspace'
      #K_NUMPADSTAR  * *3
      #K_LALT  Alt
      K_CAPSLOCK = 'CapsLock'
      #K_NUMPADMINUS - *3
      #K_NUMPADPLUS  + *3
      #K_NUMPADPERIOD  . *3
      #K_NUMPADSLASH / *3
      #K_RALT  Alt
      K_UPARROW = 'ArrowUp'
      #K_PGUP = "PageUp"
      K_LEFTARROW = 'ArrowLeft'
      K_RIGHTARROW = 'ArrowRight'
      K_DOWNARROW = 'ArrowDown'
      #K_PGDN = "PageDown"
    end
  end
end

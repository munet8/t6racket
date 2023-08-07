;-------------------------------------------------------------------------------
; コンパイルオプション
#packopt name "t6racket.exe"
#packopt type 0
#packopt xsize 320
#packopt ysize 480
#pack "fon_cha1.png"
#pack "fon_cha2.png"

;-------------------------------------------------------------------------------

; フォント画像の分割サイズ
#const global g_font_png_x 16
#const global g_font_png_y 32

; フォントサイズ（スクリーンサイズ比）
;#const global g_font_x 12
;#const global g_font_y 24
g_font_x = ginfo_winx / 25
g_font_y = ginfo_winy / 20

; スクリーンサイズ
;#const global g_screen_x 320
;#const global g_screen_y 480
g_screen_x = ginfo_winx
g_screen_y = ginfo_winy

; ブランド名 tan6°
g_tan6 = "tan6 "
poke g_tan6, 4, 127

#module
#defcfunc log10 int _x
	; log10(x)
	; 常用対数（切捨て）を返す
	if ( _x <= 0 ) {
		ret = 0
	} else {
		ret = int ( logf(_x) / logf(10) )
	}
	return ret
#global

#module
#deffunc fprint str _p1, int _alpha
	;	fprint "message"
	;	(画像を使用したフォント表示を行ないます)
	;	"message" : 表示するメッセージ
	;	表示座標は、posで指定した位置から
	;	半角カナは全角フォント画像より読み取る
	;
	i = 0: st = _p1
	fx = double( 1.0 * g_font_x@ / g_font_png_x@ )
	fy = double( 1.0 * g_font_y@ / g_font_png_y@ )

	gmode 5, 0, 0, _alpha

	repeat
		a1 = peek(st, i) :i++
		if a1 = 0 :break
		if a1 = 13 { ; 改行
			a1 = peek(st, i)
			if a1 = 10 :i++
			continue
		} else {
			if ( a1 & 128 ) {
				celput 3 , a1 - 160, fx, fy
			} else {
				celput 2 , a1 - 32, fx, fy
			}
		}
	loop

	return
#global

#module
#deffunc swap_bound var _d1, var _d2
	; swap_bound( d1, d2 )
	; 跳ね返り時の速度入れ替え
	f = _d1
	if ( _d1 > 0 ) :_d1 = -absf(_d2) :else :_d1 = absf(_d2)
	if ( _d2 > 0 ) :_d2 = absf(f) :else :_d2 = -absf(f)
	return
#global

#module
#defcfunc zone_rnd int _f, int _s
	; zone_rnd( _f, _s )
	; 通常・イベント時間の設定
	; _f :フレーム
	; _s :0 なら 通常時間。 1 なら イベント時間。 2 なら イベント種類。
	ret = 0
	level =  2
	if ( _f < 8000 ) :level =  1
	if ( _f < 4000 ) :level =  0
	switch level
	case 0:
		switch _s
		case 0 :ret = 300 + rnd(1200) :swbreak
		case 1 :ret = 200 + rnd(800)  :swbreak
		case 2 :ret =   1 + rnd(7)    :swbreak
		swend
		swbreak
	case 1:
		switch _s
		case 0 :ret = 200 + rnd(600) :swbreak
		case 1 :ret = 200 + rnd(200) :swbreak
		case 2 :ret =   1 + rnd(7)   :swbreak
		swend
		swbreak
	case 2:
		switch _s
		case 0 :ret = 50 + rnd(1200) :swbreak
		case 1 :ret = 50 + rnd(800)  :swbreak
		case 2 :ret =   1 + rnd(7)   :swbreak
		swend
		swbreak
	swend
	return ret
#global

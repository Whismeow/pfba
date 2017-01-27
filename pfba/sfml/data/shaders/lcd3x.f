#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
out vec4 FragColor;
#else
#define COMPAT_VARYING varying
#define FragColor gl_FragColor
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif
COMPAT_VARYING     float _frame_rotation;
struct input_dummy {
    vec2 _video_size;
    vec2 _texture_size;
    vec2 _output_dummy_size;
    float _frame_count;
    float _frame_direction;
    float _frame_rotation;
};
vec4 _ret_0;
vec3 _TMP2;
float _TMP5;
float _TMP4;
float _TMP3;
float _TMP1;
vec4 _TMP0;
uniform sampler2D Texture;
vec3 _x0015;
COMPAT_VARYING vec4 TEX2;
COMPAT_VARYING vec4 TEX0;

uniform int FrameDirection;
uniform int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;
void main()
{
    vec2 _angle;
    float _yfactor;
    vec3 _xfactors;
    vec3 _color;
    _TMP0 = COMPAT_TEXTURE(Texture, TEX0.xy);
    _angle = TEX0.xy*TEX2.xy;
    _TMP1 = sin(_angle.y);
    _yfactor = (1.60000000E+01 + _TMP1)/1.70000000E+01;
    _x0015 = _angle.x + vec3( 1.57079637E+00, -5.23598850E-01, -2.61799407E+00);
    _TMP3 = sin(_x0015.x);
    _TMP4 = sin(_x0015.y);
    _TMP5 = sin(_x0015.z);
    _TMP2 = vec3(_TMP3, _TMP4, _TMP5);
    _xfactors = (4.00000000E+00 + _TMP2)/5.00000000E+00;
    _color = (_yfactor*_xfactors)*_TMP0.xyz;
    _ret_0 = vec4(_color.x, _color.y, _color.z, 1.00000000E+00);
    FragColor = _ret_0;
    return;
}

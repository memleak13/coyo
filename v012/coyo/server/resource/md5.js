/*
 *  md5.js 1.0b 27/06/96
 *
 * Javascript implementation of the RSA Data Security, Inc. MD5
 * Message-Digest Algorithm.
 *
 * Copyright (c) 1996 Henri Torgemane. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * and its documentation for any purposes and without
 * fee is hereby granted provided that this copyright notice
 * appears in all copies.
 *
 * Of course, this soft is provided "as is" without express or implied
 * warranty of any kind.
 *
 *
 * Modified with german comments and some information about collisions.
 * (Ralf Mieke, ralf@miekenet.de, http://mieke.home.pages.de)
 *
 * Function renaming (because of namespace clashes) to md5_FUN()
 * Removing the german Umlaut in a comment.
 * (Gisbert Ott, ott at itchigo.com)
 */



function md5_array(n) {
  for(i=0;i<n;i++) this[i]=0;
  this.length=n;
}



/* Einige grundlegenden Funktionen muessen wegen
 * Javascript Fehlern umgeschrieben werden.
 * Man versuche z.B. 0xffffffff >> 4 zu berechnen..
 * Die nun verwendeten Funktionen sind zwar langsamer als die Originale,
 * aber sie funktionieren.
 */

function md5_integer(n) { return n%(0xffffffff+1); }

function md5_shr(a,b) {
  a=md5_integer(a);
  b=md5_integer(b);
  if (a-0x80000000>=0) {
    a=a%0x80000000;
    a>>=b;
    a+=0x40000000>>(b-1);
  } else
    a>>=b;
  return a;
}

function md5_shl1(a) {
  a=a%0x80000000;
  if (a&0x40000000==0x40000000)
  {
    a-=0x40000000;
    a*=2;
    a+=0x80000000;
  } else
    a*=2;
  return a;
}

function md5_shl(a,b) {
  a=md5_integer(a);
  b=md5_integer(b);
  for (var i=0;i<b;i++) a=md5_shl1(a);
  return a;
}

function md5_and(a,b) {
  a=md5_integer(a);
  b=md5_integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1&t2)+0x80000000);
    else
      return (t1&b);
  else
    if (t2>=0)
      return (a&t2);
    else
      return (a&b);
}

function md5_or(a,b) {
  a=md5_integer(a);
  b=md5_integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1|t2)+0x80000000);
    else
      return ((t1|b)+0x80000000);
  else
    if (t2>=0)
      return ((a|t2)+0x80000000);
    else
      return (a|b);
}

function md5_xor(a,b) {
  a=md5_integer(a);
  b=md5_integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return (t1^t2);
    else
      return ((t1^b)+0x80000000);
  else
    if (t2>=0)
      return ((a^t2)+0x80000000);
    else
      return (a^b);
}

function md5_not(a) {
  a=md5_integer(a);
  return (0xffffffff-a);
}

/* Beginn des Algorithmus */

    var state = new md5_array(4);
    var count = new md5_array(2);
        count[0] = 0;
        count[1] = 0;
    var buffer = new md5_array(64);
    var transformBuffer = new md5_array(16);
    var digestBits = new md5_array(16);

    var S11 = 7;
    var S12 = 12;
    var S13 = 17;
    var S14 = 22;
    var S21 = 5;
    var S22 = 9;
    var S23 = 14;
    var S24 = 20;
    var S31 = 4;
    var S32 = 11;
    var S33 = 16;
    var S34 = 23;
    var S41 = 6;
    var S42 = 10;
    var S43 = 15;
    var S44 = 21;

    function md5_F(x,y,z) {
        return md5_or(md5_and(x,y),md5_and(md5_not(x),z));
    }

    function md5_G(x,y,z) {
        return md5_or(md5_and(x,z),md5_and(y,md5_not(z)));
    }

    function md5_H(x,y,z) {
        return md5_xor(md5_xor(x,y),z);
    }

    function md5_I(x,y,z) {
        return md5_xor(y ,md5_or(x , md5_not(z)));
    }

    function md5_rotateLeft(a,n) {
        return md5_or(md5_shl(a, n),(md5_shr(a,(32 - n))));
    }

    function md5_FF(a,b,c,d,x,s,ac) {
        a = a+md5_F(b, c, d) + x + ac;
        a = md5_rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function md5_GG(a,b,c,d,x,s,ac) {
        a = a+md5_G(b, c, d) +x + ac;
        a = md5_rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function md5_HH(a,b,c,d,x,s,ac) {
        a = a+md5_H(b, c, d) + x + ac;
        a = md5_rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function md5_II(a,b,c,d,x,s,ac) {
        a = a+md5_I(b, c, d) + x + ac;
        a = md5_rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function md5_transform(buf,offset) {
        var a=0, b=0, c=0, d=0;
        var x = transformBuffer;

        a = state[0];
        b = state[1];
        c = state[2];
        d = state[3];

        for (i = 0; i < 16; i++) {
            x[i] = md5_and(buf[i*4+offset],0xff);
            for (j = 1; j < 4; j++) {
                x[i]+=md5_shl(md5_and(buf[i*4+j+offset] ,0xff), j * 8);
            }
        }

        /* Runde 1 */
        a = md5_FF ( a, b, c, d, x[ 0], S11, 0xd76aa478); /* 1 */
        d = md5_FF ( d, a, b, c, x[ 1], S12, 0xe8c7b756); /* 2 */
        c = md5_FF ( c, d, a, b, x[ 2], S13, 0x242070db); /* 3 */
        b = md5_FF ( b, c, d, a, x[ 3], S14, 0xc1bdceee); /* 4 */
        a = md5_FF ( a, b, c, d, x[ 4], S11, 0xf57c0faf); /* 5 */
        d = md5_FF ( d, a, b, c, x[ 5], S12, 0x4787c62a); /* 6 */
        c = md5_FF ( c, d, a, b, x[ 6], S13, 0xa8304613); /* 7 */
        b = md5_FF ( b, c, d, a, x[ 7], S14, 0xfd469501); /* 8 */
        a = md5_FF ( a, b, c, d, x[ 8], S11, 0x698098d8); /* 9 */
        d = md5_FF ( d, a, b, c, x[ 9], S12, 0x8b44f7af); /* 10 */
        c = md5_FF ( c, d, a, b, x[10], S13, 0xffff5bb1); /* 11 */
        b = md5_FF ( b, c, d, a, x[11], S14, 0x895cd7be); /* 12 */
        a = md5_FF ( a, b, c, d, x[12], S11, 0x6b901122); /* 13 */
        d = md5_FF ( d, a, b, c, x[13], S12, 0xfd987193); /* 14 */
        c = md5_FF ( c, d, a, b, x[14], S13, 0xa679438e); /* 15 */
        b = md5_FF ( b, c, d, a, x[15], S14, 0x49b40821); /* 16 */

        /* Runde 2 */
        a = md5_GG ( a, b, c, d, x[ 1], S21, 0xf61e2562); /* 17 */
        d = md5_GG ( d, a, b, c, x[ 6], S22, 0xc040b340); /* 18 */
        c = md5_GG ( c, d, a, b, x[11], S23, 0x265e5a51); /* 19 */
        b = md5_GG ( b, c, d, a, x[ 0], S24, 0xe9b6c7aa); /* 20 */
        a = md5_GG ( a, b, c, d, x[ 5], S21, 0xd62f105d); /* 21 */
        d = md5_GG ( d, a, b, c, x[10], S22,  0x2441453); /* 22 */
        c = md5_GG ( c, d, a, b, x[15], S23, 0xd8a1e681); /* 23 */
        b = md5_GG ( b, c, d, a, x[ 4], S24, 0xe7d3fbc8); /* 24 */
        a = md5_GG ( a, b, c, d, x[ 9], S21, 0x21e1cde6); /* 25 */
        d = md5_GG ( d, a, b, c, x[14], S22, 0xc33707d6); /* 26 */
        c = md5_GG ( c, d, a, b, x[ 3], S23, 0xf4d50d87); /* 27 */
        b = md5_GG ( b, c, d, a, x[ 8], S24, 0x455a14ed); /* 28 */
        a = md5_GG ( a, b, c, d, x[13], S21, 0xa9e3e905); /* 29 */
        d = md5_GG ( d, a, b, c, x[ 2], S22, 0xfcefa3f8); /* 30 */
        c = md5_GG ( c, d, a, b, x[ 7], S23, 0x676f02d9); /* 31 */
        b = md5_GG ( b, c, d, a, x[12], S24, 0x8d2a4c8a); /* 32 */

        /* Runde 3 */
        a = md5_HH ( a, b, c, d, x[ 5], S31, 0xfffa3942); /* 33 */
        d = md5_HH ( d, a, b, c, x[ 8], S32, 0x8771f681); /* 34 */
        c = md5_HH ( c, d, a, b, x[11], S33, 0x6d9d6122); /* 35 */
        b = md5_HH ( b, c, d, a, x[14], S34, 0xfde5380c); /* 36 */
        a = md5_HH ( a, b, c, d, x[ 1], S31, 0xa4beea44); /* 37 */
        d = md5_HH ( d, a, b, c, x[ 4], S32, 0x4bdecfa9); /* 38 */
        c = md5_HH ( c, d, a, b, x[ 7], S33, 0xf6bb4b60); /* 39 */
        b = md5_HH ( b, c, d, a, x[10], S34, 0xbebfbc70); /* 40 */
        a = md5_HH ( a, b, c, d, x[13], S31, 0x289b7ec6); /* 41 */
        d = md5_HH ( d, a, b, c, x[ 0], S32, 0xeaa127fa); /* 42 */
        c = md5_HH ( c, d, a, b, x[ 3], S33, 0xd4ef3085); /* 43 */
        b = md5_HH ( b, c, d, a, x[ 6], S34,  0x4881d05); /* 44 */
        a = md5_HH ( a, b, c, d, x[ 9], S31, 0xd9d4d039); /* 45 */
        d = md5_HH ( d, a, b, c, x[12], S32, 0xe6db99e5); /* 46 */
        c = md5_HH ( c, d, a, b, x[15], S33, 0x1fa27cf8); /* 47 */
        b = md5_HH ( b, c, d, a, x[ 2], S34, 0xc4ac5665); /* 48 */

        /* Runde 4 */
        a = md5_II ( a, b, c, d, x[ 0], S41, 0xf4292244); /* 49 */
        d = md5_II ( d, a, b, c, x[ 7], S42, 0x432aff97); /* 50 */
        c = md5_II ( c, d, a, b, x[14], S43, 0xab9423a7); /* 51 */
        b = md5_II ( b, c, d, a, x[ 5], S44, 0xfc93a039); /* 52 */
        a = md5_II ( a, b, c, d, x[12], S41, 0x655b59c3); /* 53 */
        d = md5_II ( d, a, b, c, x[ 3], S42, 0x8f0ccc92); /* 54 */
        c = md5_II ( c, d, a, b, x[10], S43, 0xffeff47d); /* 55 */
        b = md5_II ( b, c, d, a, x[ 1], S44, 0x85845dd1); /* 56 */
        a = md5_II ( a, b, c, d, x[ 8], S41, 0x6fa87e4f); /* 57 */
        d = md5_II ( d, a, b, c, x[15], S42, 0xfe2ce6e0); /* 58 */
        c = md5_II ( c, d, a, b, x[ 6], S43, 0xa3014314); /* 59 */
        b = md5_II ( b, c, d, a, x[13], S44, 0x4e0811a1); /* 60 */
        a = md5_II ( a, b, c, d, x[ 4], S41, 0xf7537e82); /* 61 */
        d = md5_II ( d, a, b, c, x[11], S42, 0xbd3af235); /* 62 */
        c = md5_II ( c, d, a, b, x[ 2], S43, 0x2ad7d2bb); /* 63 */
        b = md5_II ( b, c, d, a, x[ 9], S44, 0xeb86d391); /* 64 */

        state[0] +=a;
        state[1] +=b;
        state[2] +=c;
        state[3] +=d;

    }
    /* Mit der Initialisierung von Dobbertin:
       state[0] = 0x12ac2375;
       state[1] = 0x3b341042;
       state[2] = 0x5f62b97c;
       state[3] = 0x4ba763ed;
       gibt es eine Kollision:

       begin 644 Message1
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHR%C4:G1R:Q"=
       `
       end

       begin 644 Message2
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHREC4:G1R:Q"=
       `
       end
    */
    function md5_init() {
        count[0]=count[1] = 0;
        state[0] = 0x67452301;
        state[1] = 0xefcdab89;
        state[2] = 0x98badcfe;
        state[3] = 0x10325476;
        for (i = 0; i < digestBits.length; i++)
            digestBits[i] = 0;
    }

    function md5_update(b) {
        var index,i;

        index = md5_and(md5_shr(count[0],3) , 0x3f);
        if (count[0]<0xffffffff-7)
          count[0] += 8;
        else {
          count[1]++;
          count[0]-=0xffffffff+1;
          count[0]+=8;
        }
        buffer[index] = md5_and(b,0xff);
        if (index  >= 63) {
            md5_transform(buffer, 0);
        }
    }

    function md5_finish() {
        var bits = new md5_array(8);
        var        padding;
        var        i=0, index=0, padLen=0;

        for (i = 0; i < 4; i++) {
            bits[i] = md5_and(md5_shr(count[0],(i * 8)), 0xff);
        }
        for (i = 0; i < 4; i++) {
            bits[i+4]=md5_and(md5_shr(count[1],(i * 8)), 0xff);
        }
        index = md5_and(md5_shr(count[0], 3) ,0x3f);
        padLen = (index < 56) ? (56 - index) : (120 - index);
        padding = new md5_array(64);
        padding[0] = 0x80;
        for (i=0;i<padLen;i++)
          md5_update(padding[i]);
        for (i=0;i<8;i++)
          md5_update(bits[i]);

        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                digestBits[i*4+j] = md5_and(md5_shr(state[i], (j * 8)) , 0xff);
            }
        }
    }

/* Ende des MD5 Algorithmus */

function hexa(n) {
 var hexa_h = "0123456789abcdef";
 var hexa_c="";
 var hexa_m=n;
 for (hexa_i=0;hexa_i<8;hexa_i++) {
   hexa_c=hexa_h.charAt(Math.abs(hexa_m)%16)+hexa_c;
   hexa_m=Math.floor(hexa_m/16);
 }
 return hexa_c;
}


var ascii="01234567890123456789012345678901" +
          " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
          "[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

function MD5(nachricht)
{
 var l,s,k,ka,kb,kc,kd;

 md5_init();
 for (k=0;k<nachricht.length;k++) {
   l=nachricht.charAt(k);
   md5_update(ascii.lastIndexOf(l));
 }
 md5_finish();
 ka=kb=kc=kd=0;
 for (i=0;i<4;i++) ka+=md5_shl(digestBits[15-i], (i*8));
 for (i=4;i<8;i++) kb+=md5_shl(digestBits[15-i], ((i-4)*8));
 for (i=8;i<12;i++) kc+=md5_shl(digestBits[15-i], ((i-8)*8));
 for (i=12;i<16;i++) kd+=md5_shl(digestBits[15-i], ((i-12)*8));
 s=hexa(kd)+hexa(kc)+hexa(kb)+hexa(ka);
 return s;
}

/* 
 * End of original file "md5.js".
 * Added a wrapper function
 * (Gisbert Ott, ott at itchigo.com)
 */

function hex_md5(s)
{
 return(MD5(s));
}

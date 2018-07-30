{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fabio-${version}";
  version = "1.5.9";
  rev = "v${version}";

  goPackagePath = "github.com/fabiolb/fabio";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "fabiolb";
    repo = "fabio";
    inherit rev;
    sha256 = "16vzlv97s8j8i03d86bmzzkm3rahpivy4swa5gvjv4l2n38gmkdx";
  };

  meta = with stdenv.lib; {
    homepage = https://fabiolb.net/;
    description = "Consul Load-Balancing made simple";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}


/* {
  "url": "https://github.com/fabiolb/fabio",
  "rev": "79d46e3822db28d7d07073f3675c59a7141968b4",
  "date": "2018-07-27T07:09:05+02:00",
  "sha256": "0x46h9irdc4pxs570cxmjv3a4kgb11l4v3i4zlmhgafnphgkjmx0",
  "fetchSubmodules": true
} */

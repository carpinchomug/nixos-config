{ fetchFromGitHub
, bazel
, buildBazelPackage
, pkg-config
, fcitx5
, python3
, qt6
}:

buildBazelPackage {
  inherit bazel;

  pname = "fcitx5-mozc";
  version = "2.29.5200.102";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    rev = "198608e08393dd26a81cd091e4916dfbc4196e5e";
    sha256 = "sha256-6hTFCohmz+ijwWLQu65kKpiihs7XKqph3/JDwQjSHBw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    python3
    qt6.wrapQtAppsHook
  ];
  buildInputs = [ fcitx5 qt6.qtbase ];

  bazelFlags = [
    "-c opt"
    "--config oss_linux"
  ];

  bazelTargets = [
    "unix/fcitx5:fcitx5-mozc.so"
    "server:mozc_server"
    "gui/tool:mozc_tool"
    "unix/emacs:mozc_emacs_helper"
  ];

  removeRulesCC = false;

  fetchAttrs = {
    sha256 = "sha256-0AtOO3SzTiNo50ldpPqHy4pwMEGWNfizrJHdT1Hmsk8=";
  };

  preBuild = ''
    cd src

    sed -i "s|^LINUX_MOZC_SERVER_DIR.*|LINUX_MOZC_SERVER_DIR = \"$out/lib/mozc\"|g" config.bzl
    sed -i "s|^EMACS_MOZC_HELPER_DIR.*|EMACS_MOZC_HELPER_DIR  = \"$out/bin\"|g" config.bzl
  '';

  dontAddBazelOpts = true;

  buildAttrs = {
    installPhase = ''
      runHook preInstall

      install -D -m 755 bazel-bin/server/mozc_server $out/lib/mozc/mozc_server
      install -D -m 755 bazel-bin/gui/tool/mozc_tool $out/lib/mozc/mozc_tool
      install -d $out/share/doc/mozc/
      install -m 644 data/installer/*.html $out/share/doc/mozc/

      install -D -m 755 bazel-bin/unix/emacs/mozc_emacs_helper $out/bin/mozc_emacs_helper

      install -D -m 755 bazel-bin/unix/fcitx5/fcitx5-mozc.so $out/lib/fcitx5/fcitx5-mozc.so

      for pofile in unix/fcitx5/po/*.po
      do
          filename=`basename $pofile`
          lang=''${filename/.po/}
          mofile=''${pofile/.po/.mo}
          msgfmt $pofile -o $mofile
          install -D -m 644 $mofile $out/share/locale/$lang/LC_MESSAGES/fcitx5-mozc.mo
          rm -f $mofile
      done

      install -D -m 644 unix/fcitx5/mozc-addon.conf $out/share/fcitx5/addon/mozc.conf
      install -D -m 644 unix/fcitx5/mozc.conf $out/share/fcitx5/inputmethod/mozc.conf

      install -D -m 644 data/images/product_icon_32bpp-128.png $out/share/icons/hicolor/128x128/apps/org.fcitx.Fcitx5.fcitx-mozc.png
      install -D -m 644 data/images/unix/ime_product_icon_opensource-32.png $out/share/icons/hicolor/32x32/apps/org.fcitx.Fcitx5.fcitx-mozc.png
      install -D -m 644 ../scripts/icons/ui-alpha_full.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-alpha-full.png
      install -D -m 644 ../scripts/icons/ui-alpha_half.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-alpha-half.png
      install -D -m 644 ../scripts/icons/ui-direct.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-direct.png
      install -D -m 644 ../scripts/icons/ui-hiragana.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-hiragana.png
      install -D -m 644 ../scripts/icons/ui-katakana_full.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-katakana-full.png
      install -D -m 644 ../scripts/icons/ui-katakana_half.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-katakana-half.png
      install -D -m 644 ../scripts/icons/ui-dictionary.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-dictionary.png
      install -D -m 644 ../scripts/icons/ui-properties.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-properties.png
      install -D -m 644 ../scripts/icons/ui-tool.png $out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-mozc-tool.png

      ln -sf org.fcitx.Fcitx5.fcitx-mozc.png $out/share/icons/hicolor/128x128/apps/fcitx-mozc.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc.png $out/share/icons/hicolor/32x32/apps/fcitx-mozc.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-alpha-full.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-alpha-full.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-alpha-half.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-alpha-half.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-direct.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-direct.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-hiragana.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-hiragana.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-katakana-full.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-katakana-full.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-katakana-half.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-katakana-half.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-dictionary.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-dictionary.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-properties.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-properties.png
      ln -sf org.fcitx.Fcitx5.fcitx-mozc-tool.png $out/share/icons/hicolor/48x48/apps/fcitx-mozc-tool.png

      msgfmt --xml -d unix/fcitx5/po/ --template unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml.in -o unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml
      install -Dm644 unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml $out/share/metainfo/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml
      rm -f unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml

      runHook postInstall
    '';

    preFixup = ''
      wrapQtApp $out/lib/mozc/mozc_tool
    '';
  };
}

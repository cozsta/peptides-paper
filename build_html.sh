#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
OUT="${1:-docs}"
mkdir -p "$OUT"
title_for(){ case "$1" in
  ru) printf '%s' "Пептиды · что работает, что опасно";;
  en) printf '%s' "Peptides - what works, what is dangerous";;
  zh) printf '%s' "肽类指南 · 什么有效，什么危险";;
esac; }
for L in ru en zh; do
  [ -f "$L.md" ] || { echo "skip $L"; continue; }
  pandoc "$L.md" --template template.html --toc --toc-depth=2 \
    --metadata title="$(title_for "$L")" --metadata lang="$L" \
    -f markdown+smart-yaml_metadata_block-multiline_tables-simple_tables-grid_tables-pipe_tables -t html5 \
    -o "$OUT/$L.html"
  echo "built $OUT/$L.html"
done
cat > "$OUT/index.html" <<'HTML'
<!doctype html><html lang="ru"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Peptides · Пептиды · 肽类</title>
<style>
  :root{color-scheme:light dark}
  body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
       min-height:100vh;margin:0;display:flex;flex-direction:column;
       align-items:center;justify-content:center;gap:1.6rem;padding:2rem 1rem;
       background:#0b0b0c;color:#e9e9ea}
  @media (prefers-color-scheme:light){body{background:#fafafa;color:#1a1a1a}}
  h1{font-size:1.15rem;font-weight:700;text-align:center;margin:0;opacity:.9;line-height:1.5}
  .sub{opacity:.55;font-size:.85rem;text-align:center;max-width:30rem;line-height:1.6}
  .langs{display:flex;gap:.8rem;flex-wrap:wrap;justify-content:center}
  .langs a{display:block;padding:.85rem 1.6rem;border-radius:.7rem;
           border:1px solid #8884;text-decoration:none;color:inherit;
           font-weight:600;font-size:1.05rem;transition:.15s}
  .langs a:hover{border-color:#c0392b;color:#e74c3c}
</style></head>
<body>
  <h1>Пептиды: что работает, что хайп, что опасно<br>· Peptides · 肽类</h1>
  <nav class="langs">
    <a href="ru.html">Русский</a>
    <a href="en.html">English</a>
    <a href="zh.html">中文</a>
  </nav>
  <p class="sub">Обзор по исследованиям · не медицинский совет · A research overview, not medical advice · 研究综述，非医疗建议</p>
</body></html>
HTML
echo "wrote $OUT/index.html"
echo ".nojekyll for GitHub Pages"; touch "$OUT/.nojekyll"

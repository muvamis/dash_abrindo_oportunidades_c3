
/* ==========================================================================
   ABRINDO OPORTUNIDADES CIII — Português / English / Français
   --------------------------------------------------------------------------
   - Alternância PT | EN | FR
   - Guarda o idioma no navegador
   - Dicionário com três idiomas
   - Compatível com entradas antigas PT/EN
   - Traduz conteúdos dinâmicos do Shiny
   - Não altera dados, cálculos ou valores dos gráficos
   ========================================================================== */

(function () {
  'use strict';

  var LS_KEY = 'abrindo_oportunidades_c3_idioma';
  var DICT_URL = 'i18n/traducoes.json';
  var SHINY_INPUT = 'idioma_app';

  var LANGS = ['pt', 'en', 'fr'];

  var LANG_INDEX = {
    pt: 0,
    en: 1,
    fr: 2
  };

  var SKIP_SELECTOR =
    'blockquote, .i18n-skip, script, style, noscript, textarea';

  var EXACT_ONLY_SELECTOR = 'td';
  var ATTRS = ['title', 'placeholder'];
  var HAS_LETTER = /[A-Za-zÀ-ɏ]/;

  var state = {
    lang: 'pt',
    loaded: false,
    data: null,
    exact: new Map(),
    fragRe: null,
    nodeRules: [],
    preRules: [],
    fragRules: []
  };

  var textStore = new WeakMap();
  var attrStore = new WeakMap();

  function norm(s) {
    return String(s).replace(/\s+/g, ' ').trim();
  }

  function escRe(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  function splitSegments(s) {
    return String(s).split(/<[^>]+>|%\{[^}]*\}|\n/);
  }

  // ------------------------------------------------------------------------
  // Obter a tradução correspondente ao idioma seleccionado
  // ------------------------------------------------------------------------

  function getTranslation(entry) {
    if (entry === undefined || entry === null) {
      return undefined;
    }

    // Formato recomendado: { en: "...", fr: "..." }
    if (typeof entry === 'object' && !Array.isArray(entry)) {
      return entry[state.lang];
    }

    // Compatibilidade com regras antigas: para: "English"
    if (state.lang === 'en' && typeof entry === 'string') {
      return entry;
    }

    return undefined;
  }

  // ------------------------------------------------------------------------
  // Construção do dicionário para o idioma seleccionado
  // ------------------------------------------------------------------------

  function build(data) {
    state.data = data;
    buildLanguage();
    state.loaded = true;
  }

  function buildLanguage() {
    var data = state.data;

    if (!data) return;

    state.exact.clear();

    var idx = LANG_INDEX[state.lang];

    (data.entradas || []).forEach(function (entry) {
      if (!Array.isArray(entry) || entry.length < 2) return;

      var original = entry[0];
      var target = entry[idx];

      // Em francês, entradas antigas com apenas PT/EN
      // permanecem no original até receberem tradução francesa.
      if (target === undefined || target === null || target === '') {
        return;
      }

      var a = splitSegments(original);
      var b = splitSegments(target);

      if (a.length !== b.length) {
        a = [String(original).replace(/<[^>]+>/g, ' ')];
        b = [String(target).replace(/<[^>]+>/g, ' ')];
      }

      for (var i = 0; i < a.length; i++) {
        var k = norm(a[i]);
        var v = norm(b[i]);

        if (!k || !HAS_LETTER.test(k)) continue;

        if (!state.exact.has(k)) {
          state.exact.set(k, v);
        }
      }
    });

    var soltas = new Set(data.palavras_em_frases || []);
    var keys = [];

    state.exact.forEach(function (v, k) {
      if (k === v) return;

      var letters = (k.match(/\p{L}/gu) || []).length;
      if (letters < 2) return;

      var isPhrase = /\s/.test(k) || /[^\p{L}]/u.test(k);

      if (isPhrase || soltas.has(k)) {
        keys.push(k);
      }
    });

    keys.sort(function (x, y) {
      return y.length - x.length;
    });

    state.fragRe = null;

    if (keys.length) {
      var parts = keys.map(function (k) {
        var e = escRe(k).replace(/ /g, '\\s+');

        if (/^[\p{L}\p{N}]/u.test(k)) {
          e = '(?<![\\p{L}\\p{N}])' + e;
        }

        if (/[\p{L}\p{N}]$/u.test(k)) {
          e += '(?![\\p{L}\\p{N}])';
        }

        return e;
      });

      state.fragRe = new RegExp(parts.join('|'), 'gu');
    }

    // Regras de texto completo
    state.nodeRules = [];

    (data.regras_texto_completo || []).forEach(function (r) {
      var target = getTranslation(r.para);

      // Compatibilidade com a propriedade antiga "fr"
      if (target === undefined && state.lang === 'fr') {
        target = r.fr;
      }

      if (target === undefined || target === null || target === '') {
        return;
      }

      state.nodeRules.push([
        new RegExp(r.de, 'u'),
        target
      ]);
    });

    // Regras parciais
    state.preRules = [];
    state.fragRules = [];

    (data.regras_parciais || []).forEach(function (r) {
      var target = getTranslation(r.para);

      if (target === undefined && state.lang === 'fr') {
        target = r.fr;
      }

      if (target === undefined || target === null || target === '') {
        return;
      }

      var rule = [new RegExp(r.de, 'gu'), target];

      if (r.fase === 'antes') {
        state.preRules.push(rule);
      } else {
        state.fragRules.push(rule);
      }
    });
  }

  // ------------------------------------------------------------------------
  // Tradução de texto
  // ------------------------------------------------------------------------

  function translateString(raw, exactOnly) {
    var n = norm(raw);

    if (!n || !HAS_LETTER.test(n)) return null;

    var lead = raw.match(/^\s*/)[0];
    var trail = raw.match(/\s*$/)[0];

    var exact = state.exact.get(n);

    if (exact !== undefined) {
      return exact === n ? null : lead + exact + trail;
    }

    for (var i = 0; i < state.nodeRules.length; i++) {
      var r = state.nodeRules[i];

      if (r[0].test(n)) {
        return lead + n.replace(r[0], r[1]) + trail;
      }
    }

    if (exactOnly) return null;

    var out = raw;

    for (var j = 0; j < state.preRules.length; j++) {
      out = out.replace(
        state.preRules[j][0],
        state.preRules[j][1]
      );
    }

    if (state.fragRe) {
      out = out.replace(state.fragRe, function (m) {
        var t = state.exact.get(norm(m));
        return t === undefined ? m : t;
      });
    }

    for (var k = 0; k < state.fragRules.length; k++) {
      out = out.replace(
        state.fragRules[k][0],
        state.fragRules[k][1]
      );
    }

    return out !== raw ? out : null;
  }

  function isSkipped(el) {
    return !el || (
      el.closest && el.closest(SKIP_SELECTOR) !== null
    );
  }

  function isExactOnly(el) {
    return !!(
      el && el.closest &&
      el.closest(EXACT_ONLY_SELECTOR)
    );
  }

  // ------------------------------------------------------------------------
  // Nós de texto
  // ------------------------------------------------------------------------

  function translateTextNode(node) {
    var el = node.parentElement;

    if (isSkipped(el)) return;

    var cur = node.nodeValue;
    var rec = textStore.get(node);

    if (rec && cur === rec.t) return;

    var t = translateString(cur, isExactOnly(el));

    if (t !== null && t !== cur) {
      textStore.set(node, { o: cur, t: t });
      node.nodeValue = t;
    } else if (rec) {
      textStore.delete(node);
    }
  }

  function restoreTextNode(node) {
    var rec = textStore.get(node);

    if (!rec) return;

    if (node.nodeValue === rec.t) {
      node.nodeValue = rec.o;
    }

    textStore.delete(node);
  }

  // ------------------------------------------------------------------------
  // Atributos HTML
  // ------------------------------------------------------------------------

  function translateAttrs(el) {
    if (isSkipped(el)) return;

    ATTRS.forEach(function (a) {
      if (!el.hasAttribute || !el.hasAttribute(a)) return;

      var cur = el.getAttribute(a);
      var recs = attrStore.get(el) || {};

      if (recs[a] && recs[a].t === cur) return;

      var t = translateString(cur, false);

      if (t !== null && t !== cur) {
        recs[a] = { o: cur, t: t };
        attrStore.set(el, recs);
        el.setAttribute(a, t);
      }
    });
  }

  function restoreAttrs(el) {
    var recs = attrStore.get(el);

    if (!recs) return;

    Object.keys(recs).forEach(function (a) {
      if (el.getAttribute(a) === recs[a].t) {
        el.setAttribute(a, recs[a].o);
      }
    });

    attrStore.delete(el);
  }

  // ------------------------------------------------------------------------
  // Percorrer a página
  // ------------------------------------------------------------------------

  function walk(root, onText, onEl) {
    if (!root) return;

    if (root.nodeType === 3) {
      onText(root);
      return;
    }

    if (
      root.nodeType !== 1 &&
      root.nodeType !== 9 &&
      root.nodeType !== 11
    ) {
      return;
    }

    if (root.nodeType === 1) {
      if (isSkipped(root)) return;
      onEl(root);
    }

    var tw = document.createTreeWalker(
      root,
      NodeFilter.SHOW_TEXT | NodeFilter.SHOW_ELEMENT,
      null
    );

    var n;

    while ((n = tw.nextNode())) {
      if (n.nodeType === 3) {
        onText(n);
      } else {
        onEl(n);
      }
    }
  }

  function translateTree(root) {
    walk(root, translateTextNode, translateAttrs);
  }

  function restoreTree(root) {
    walk(root, restoreTextNode, restoreAttrs);
  }

  // ------------------------------------------------------------------------
  // Observar conteúdos dinâmicos gerados pelo Shiny
  // ------------------------------------------------------------------------

  var observer = new MutationObserver(function (muts) {
    if (state.lang === 'pt' || !state.loaded) return;

    muts.forEach(function (m) {
      if (m.type === 'childList') {
        m.addedNodes.forEach(function (node) {
          translateTree(node);
        });
      } else if (m.type === 'characterData') {
        translateTextNode(m.target);
      } else if (m.type === 'attributes') {
        translateAttrs(m.target);
      }
    });
  });

  function startObserver() {
    if (!document.body) return;

    observer.observe(document.body, {
      childList: true,
      subtree: true,
      characterData: true,
      attributes: true,
      attributeFilter: ATTRS
    });
  }

  // ------------------------------------------------------------------------
  // Estilo do botão PT | EN | FR
  // ------------------------------------------------------------------------

  function injectStyle() {
    if (document.getElementById('abrindo-i18n-style')) return;

    var css =
      '#abrindo-i18n-toggle{' +
        'position:absolute;top:12px;right:16px;z-index:1031;' +
        'display:inline-flex;border:1px solid rgba(255,255,255,.85);' +
        'border-radius:14px;overflow:hidden;font-size:11px;' +
        'line-height:1;font-weight:bold;' +
      '}' +
      '#abrindo-i18n-toggle button{' +
        'background:transparent;color:#fff;border:0;' +
        'padding:6px 9px;cursor:pointer;font-weight:bold;' +
        'letter-spacing:.5px;' +
      '}' +
      '#abrindo-i18n-toggle button.active{' +
        'background:#fff;color:#8054A2;' +
      '}' +
      '#abrindo-i18n-toggle button:focus{' +
        'outline:none;' +
      '}';

    var s = document.createElement('style');
    s.id = 'abrindo-i18n-style';
    s.appendChild(document.createTextNode(css));
    document.head.appendChild(s);
  }

  // ------------------------------------------------------------------------
  // Criar o botão PT | EN | FR
  // ------------------------------------------------------------------------

  function injectToggle() {
    if (document.getElementById('abrindo-i18n-toggle')) return;

    var host = document.querySelector('.navbar') || document.body;

    var box = document.createElement('div');
    box.id = 'abrindo-i18n-toggle';
    box.className = 'i18n-skip';
    box.setAttribute('role', 'group');
    box.setAttribute('aria-label', 'Idioma / Language / Langue');

    [
      ['pt', 'PT', 'Português'],
      ['en', 'EN', 'English'],
      ['fr', 'FR', 'Français']
    ].forEach(function (o) {
      var b = document.createElement('button');

      b.type = 'button';
      b.setAttribute('data-lang', o[0]);
      b.setAttribute('title', o[2]);
      b.setAttribute('aria-label', o[2]);
      b.textContent = o[1];

      b.addEventListener('click', function () {
        setLang(o[0]);
      });

      box.appendChild(b);
    });

    host.appendChild(box);
    paintToggle();
  }

  function paintToggle() {
    var box = document.getElementById('abrindo-i18n-toggle');

    if (!box) return;

    Array.prototype.forEach.call(
      box.querySelectorAll('button'),
      function (b) {
        var on = b.getAttribute('data-lang') === state.lang;

        b.className = on ? 'active' : '';
        b.setAttribute('aria-pressed', on ? 'true' : 'false');
      }
    );
  }

  // ------------------------------------------------------------------------
  // Comunicar o idioma ao Shiny
  // ------------------------------------------------------------------------

  function notifyShiny() {
    if (
      window.Shiny &&
      typeof window.Shiny.setInputValue === 'function'
    ) {
      window.Shiny.setInputValue(
        SHINY_INPUT,
        state.lang,
        { priority: 'event' }
      );
    }
  }

  // ------------------------------------------------------------------------
  // Alterar idioma
  // ------------------------------------------------------------------------

  function setLang(lang) {
    lang = LANGS.indexOf(lang) !== -1 ? lang : 'pt';

    var changed = lang !== state.lang;

    // Restaurar os textos originais antes de mudar de idioma.
    if (state.loaded && changed && state.lang !== 'pt') {
      restoreTree(document.body);
    }

    state.lang = lang;

    try {
      window.localStorage.setItem(LS_KEY, lang);
    } catch (e) {
      // A aplicação funciona mesmo sem localStorage.
    }

    if (state.loaded) {
      buildLanguage();
    }

    paintToggle();

    if (lang !== 'pt' && state.loaded) {
      translateTree(document.body);
    } else if (lang === 'pt') {
      restoreTree(document.body);
    }

    if (changed) {
      notifyShiny();
    }
  }

  // ------------------------------------------------------------------------
  // Inicialização
  // ------------------------------------------------------------------------

  function init() {
    injectStyle();
    injectToggle();
    startObserver();

    var saved = 'pt';

    try {
      saved = window.localStorage.getItem(LS_KEY) || 'pt';
    } catch (e) {
      // Português como idioma padrão.
    }

    if (LANGS.indexOf(saved) === -1) {
      saved = 'pt';
    }

    fetch(DICT_URL, { cache: 'no-cache' })
      .then(function (r) {
        if (!r.ok) {
          throw new Error('Não foi possível carregar traducoes.json');
        }

        return r.json();
      })
      .then(function (data) {
        state.data = data;
        state.lang = 'pt';
        build(data);
        setLang(saved);
      })
      .catch(function (err) {
        if (window.console) {
          console.warn('[i18n Abrindo] Erro:', err);
        }
      });
  }

  document.addEventListener('shiny:connected', function () {
    notifyShiny();
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // API opcional para outros scripts
  window.AbrindoI18n = {
    setLang: setLang,
    getLang: function () {
      return state.lang;
    },
    translate: function (s) {
      return translateString(String(s), false) || String(s);
    }
  };

})();

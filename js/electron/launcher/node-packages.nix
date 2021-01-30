# This file has been generated by node2nix 1.8.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {
    "@electron/get-1.12.3" = {
      name = "_at_electron_slash_get";
      packageName = "@electron/get";
      version = "1.12.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/@electron/get/-/get-1.12.3.tgz";
        sha512 = "NFwSnVZQK7dhOYF1NQCt+HGqgL1aNdj0LUSx75uCqnZJqyiWCVdAMFV4b4/kC8HjUJAnsvdSEmjEt4G2qNQ9+Q==";
      };
    };
    "@sindresorhus/is-0.14.0" = {
      name = "_at_sindresorhus_slash_is";
      packageName = "@sindresorhus/is";
      version = "0.14.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@sindresorhus/is/-/is-0.14.0.tgz";
        sha512 = "9NET910DNaIPngYnLLPeg+Ogzqsi9uM4mSboU5y6p8S5DzMTVEsJZrawi+BoDNUVBa2DhJqQYUFvMDfgU062LQ==";
      };
    };
    "@szmarczak/http-timer-1.1.2" = {
      name = "_at_szmarczak_slash_http-timer";
      packageName = "@szmarczak/http-timer";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-1.1.2.tgz";
        sha512 = "XIB2XbzHTN6ieIjfIMV9hlVcfPU26s2vafYWQcZHWXHOxiaRZYEDKEwdl129Zyg50+foYV2jCgtrqSA6qNuNSA==";
      };
    };
    "@types/node-14.14.22" = {
      name = "_at_types_slash_node";
      packageName = "@types/node";
      version = "14.14.22";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/node/-/node-14.14.22.tgz";
        sha512 = "g+f/qj/cNcqKkc3tFqlXOYjrmZA+jNBiDzbP3kH+B+otKFqAdPgVTGP1IeKRdMml/aE69as5S4FqtxAbl+LaMw==";
      };
    };
    "at-least-node-1.0.0" = {
      name = "at-least-node";
      packageName = "at-least-node";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz";
        sha512 = "+q/t7Ekv1EDY2l6Gda6LLiX14rU9TV20Wa3ofeQmwPFZbOMo9DXrLbOjFaaclkXKWidIaopwAObQDqwWtGUjqg==";
      };
    };
    "boolean-3.0.2" = {
      name = "boolean";
      packageName = "boolean";
      version = "3.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/boolean/-/boolean-3.0.2.tgz";
        sha512 = "RwywHlpCRc3/Wh81MiCKun4ydaIFyW5Ea6JbL6sRCVx5q5irDw7pMXBUFYF/jArQ6YrG36q0kpovc9P/Kd3I4g==";
      };
    };
    "buffer-crc32-0.2.13" = {
      name = "buffer-crc32";
      packageName = "buffer-crc32";
      version = "0.2.13";
      src = fetchurl {
        url = "https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz";
        sha1 = "0d333e3f00eac50aa1454abd30ef8c2a5d9a7242";
      };
    };
    "buffer-from-1.1.1" = {
      name = "buffer-from";
      packageName = "buffer-from";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.1.tgz";
        sha512 = "MQcXEUbCKtEo7bhqEs6560Hyd4XaovZlO/k9V3hjVUF/zwW7KBVdSK4gIt/bzwS9MbR5qob+F5jusZsb0YQK2A==";
      };
    };
    "cacheable-request-6.1.0" = {
      name = "cacheable-request";
      packageName = "cacheable-request";
      version = "6.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/cacheable-request/-/cacheable-request-6.1.0.tgz";
        sha512 = "Oj3cAGPCqOZX7Rz64Uny2GYAZNliQSqfbePrgAQ1wKAihYmCUnraBtJtKcGR4xz7wF+LoJC+ssFZvv5BgF9Igg==";
      };
    };
    "clone-response-1.0.2" = {
      name = "clone-response";
      packageName = "clone-response";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/clone-response/-/clone-response-1.0.2.tgz";
        sha1 = "d1dc973920314df67fbeb94223b4ee350239e96b";
      };
    };
    "concat-stream-1.6.2" = {
      name = "concat-stream";
      packageName = "concat-stream";
      version = "1.6.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz";
        sha512 = "27HBghJxjiZtIk3Ycvn/4kbJk/1uZuJFfuPEns6LaEvpvG1f0hTea8lilrouyo9mVc2GWdcEZ8OLoGmSADlrCw==";
      };
    };
    "config-chain-1.1.12" = {
      name = "config-chain";
      packageName = "config-chain";
      version = "1.1.12";
      src = fetchurl {
        url = "https://registry.npmjs.org/config-chain/-/config-chain-1.1.12.tgz";
        sha512 = "a1eOIcu8+7lUInge4Rpf/n4Krkf3Dd9lqhljRzII1/Zno/kRtUWnznPO3jOKBmTEktkt3fkxisUcivoj0ebzoA==";
      };
    };
    "core-js-3.8.3" = {
      name = "core-js";
      packageName = "core-js";
      version = "3.8.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/core-js/-/core-js-3.8.3.tgz";
        sha512 = "KPYXeVZYemC2TkNEkX/01I+7yd+nX3KddKwZ1Ww7SKWdI2wQprSgLmrTddT8nw92AjEklTsPBoSdQBhbI1bQ6Q==";
      };
    };
    "core-util-is-1.0.2" = {
      name = "core-util-is";
      packageName = "core-util-is";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    };
    "debug-2.6.9" = {
      name = "debug";
      packageName = "debug";
      version = "2.6.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-2.6.9.tgz";
        sha512 = "bC7ElrdJaJnPbAP+1EotYvqZsb3ecl5wi6Bfi6BJTUcNowp6cvspg0jXznRTKDjm/E7AdgFBVeAPVMNcKGsHMA==";
      };
    };
    "debug-4.3.2" = {
      name = "debug";
      packageName = "debug";
      version = "4.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-4.3.2.tgz";
        sha512 = "mOp8wKcvj7XxC78zLgw/ZA+6TSgkoE2C/ienthhRD298T7UNwAg9diBpLRxC0mOezLl4B0xV7M0cCO6P/O0Xhw==";
      };
    };
    "decompress-response-3.3.0" = {
      name = "decompress-response";
      packageName = "decompress-response";
      version = "3.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/decompress-response/-/decompress-response-3.3.0.tgz";
        sha1 = "80a4dd323748384bfa248083622aedec982adff3";
      };
    };
    "defer-to-connect-1.1.3" = {
      name = "defer-to-connect";
      packageName = "defer-to-connect";
      version = "1.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-1.1.3.tgz";
        sha512 = "0ISdNousHvZT2EiFlZeZAHBUvSxmKswVCEf8hW7KWgG4a8MVEu/3Vb6uWYozkjylyCxe0JBIiRB1jV45S70WVQ==";
      };
    };
    "define-properties-1.1.3" = {
      name = "define-properties";
      packageName = "define-properties";
      version = "1.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/define-properties/-/define-properties-1.1.3.tgz";
        sha512 = "3MqfYKj2lLzdMSf8ZIZE/V+Zuy+BgD6f164e8K2w7dgnpKArBDerGYpM46IYYcjnkdPNMjPk9A6VFB8+3SKlXQ==";
      };
    };
    "detect-node-2.0.4" = {
      name = "detect-node";
      packageName = "detect-node";
      version = "2.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/detect-node/-/detect-node-2.0.4.tgz";
        sha512 = "ZIzRpLJrOj7jjP2miAtgqIfmzbxa4ZOr5jJc601zklsfEx9oTzmmj2nVpIPRpNlRTIh8lc1kyViIY7BWSGNmKw==";
      };
    };
    "duplexer3-0.1.4" = {
      name = "duplexer3";
      packageName = "duplexer3";
      version = "0.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.4.tgz";
        sha1 = "ee01dd1cac0ed3cbc7fdbea37dc0a8f1ce002ce2";
      };
    };
    "electron-12.0.0-beta.16" = {
      name = "electron";
      packageName = "electron";
      version = "12.0.0-beta.16";
      src = fetchurl {
        url = "https://registry.npmjs.org/electron/-/electron-12.0.0-beta.16.tgz";
        sha512 = "8fsosa7PLnfheNqVK5G+NToZBh4audSVJIwff4vKorCkNK3XDMQCoHD9JKFeVRczYlb4YEY2mh7SsX4C8p9FMQ==";
      };
    };
    "encodeurl-1.0.2" = {
      name = "encodeurl";
      packageName = "encodeurl";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz";
        sha1 = "ad3ff4c86ec2d029322f5a02c3a9a606c95b3f59";
      };
    };
    "end-of-stream-1.4.4" = {
      name = "end-of-stream";
      packageName = "end-of-stream";
      version = "1.4.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz";
        sha512 = "+uw1inIHVPQoaVuHzRyXd21icM+cnt4CzD5rW+NC1wjOUSTOs+Te7FOv7AhN7vS9x/oIyhLP5PR1H+phQAHu5Q==";
      };
    };
    "env-paths-2.2.0" = {
      name = "env-paths";
      packageName = "env-paths";
      version = "2.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/env-paths/-/env-paths-2.2.0.tgz";
        sha512 = "6u0VYSCo/OW6IoD5WCLLy9JUGARbamfSavcNXry/eu8aHVFei6CD3Sw+VGX5alea1i9pgPHW0mbu6Xj0uBh7gA==";
      };
    };
    "es6-error-4.1.1" = {
      name = "es6-error";
      packageName = "es6-error";
      version = "4.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz";
        sha512 = "Um/+FxMr9CISWh0bi5Zv0iOD+4cFh5qLeks1qhAopKVAJw3drgKbKySikp7wGhDL0HPeaja0P5ULZrxLkniUVg==";
      };
    };
    "escape-string-regexp-1.0.5" = {
      name = "escape-string-regexp";
      packageName = "escape-string-regexp";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    };
    "escape-string-regexp-4.0.0" = {
      name = "escape-string-regexp";
      packageName = "escape-string-regexp";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz";
        sha512 = "TtpcNJ3XAzx3Gq8sWRzJaVajRs0uVxA2YAkdb1jm2YkPz4G6egUFAyA3n5vtEIZefPk5Wa4UXbKuS5fKkJWdgA==";
      };
    };
    "extract-zip-1.7.0" = {
      name = "extract-zip";
      packageName = "extract-zip";
      version = "1.7.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz";
        sha512 = "xoh5G1W/PB0/27lXgMQyIhP5DSY/LhoCsOyZgb+6iMmRtCwVBo55uKaMoEYrDCKQhWvqEip5ZPKAc6eFNyf/MA==";
      };
    };
    "fd-slicer-1.1.0" = {
      name = "fd-slicer";
      packageName = "fd-slicer";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz";
        sha1 = "25c7c89cb1f9077f8891bbe61d8f390eae256f1e";
      };
    };
    "filename-reserved-regex-2.0.0" = {
      name = "filename-reserved-regex";
      packageName = "filename-reserved-regex";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/filename-reserved-regex/-/filename-reserved-regex-2.0.0.tgz";
        sha1 = "abf73dfab735d045440abfea2d91f389ebbfa229";
      };
    };
    "filenamify-4.2.0" = {
      name = "filenamify";
      packageName = "filenamify";
      version = "4.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/filenamify/-/filenamify-4.2.0.tgz";
        sha512 = "pkgE+4p7N1n7QieOopmn3TqJaefjdWXwEkj2XLZJLKfOgcQKkn11ahvGNgTD8mLggexLiDFQxeTs14xVU22XPA==";
      };
    };
    "fs-extra-8.1.0" = {
      name = "fs-extra";
      packageName = "fs-extra";
      version = "8.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz";
        sha512 = "yhlQgA6mnOJUKOsRUFsgJdQCvkKhcz8tlZG5HBQfReYZy46OwLcY+Zia0mtdHsOo9y/hP+CxMN0TU9QxoOtG4g==";
      };
    };
    "fs-extra-9.1.0" = {
      name = "fs-extra";
      packageName = "fs-extra";
      version = "9.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz";
        sha512 = "hcg3ZmepS30/7BSFqRvoo3DOMQu7IjqxO5nCDt+zM9XWjb33Wg7ziNT+Qvqbuc3+gWpzO02JubVyk2G4Zvo1OQ==";
      };
    };
    "get-stream-4.1.0" = {
      name = "get-stream";
      packageName = "get-stream";
      version = "4.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz";
        sha512 = "GMat4EJ5161kIy2HevLlr4luNjBgvmj413KaQA7jt4V8B4RDsfpHk7WQ9GVqfYyyx8OS/L66Kox+rJRNklLK7w==";
      };
    };
    "get-stream-5.2.0" = {
      name = "get-stream";
      packageName = "get-stream";
      version = "5.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz";
        sha512 = "nBF+F1rAZVCu/p7rjzgA+Yb4lfYXrpl7a6VmJrU8wF9I1CKvP/QwPNZHnOlwbTkY6dvtFIzFMSyQXbLoTQPRpA==";
      };
    };
    "global-agent-2.1.12" = {
      name = "global-agent";
      packageName = "global-agent";
      version = "2.1.12";
      src = fetchurl {
        url = "https://registry.npmjs.org/global-agent/-/global-agent-2.1.12.tgz";
        sha512 = "caAljRMS/qcDo69X9BfkgrihGUgGx44Fb4QQToNQjsiWh+YlQ66uqYVAdA8Olqit+5Ng0nkz09je3ZzANMZcjg==";
      };
    };
    "global-tunnel-ng-2.7.1" = {
      name = "global-tunnel-ng";
      packageName = "global-tunnel-ng";
      version = "2.7.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz";
        sha512 = "4s+DyciWBV0eK148wqXxcmVAbFVPqtc3sEtUE/GTQfuU80rySLcMhUmHKSHI7/LDj8q0gDYI1lIhRRB7ieRAqg==";
      };
    };
    "globalthis-1.0.1" = {
      name = "globalthis";
      packageName = "globalthis";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/globalthis/-/globalthis-1.0.1.tgz";
        sha512 = "mJPRTc/P39NH/iNG4mXa9aIhNymaQikTrnspeCa2ZuJ+mH2QN/rXwtX3XwKrHqWgUQFbNZKtHM105aHzJalElw==";
      };
    };
    "got-9.6.0" = {
      name = "got";
      packageName = "got";
      version = "9.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/got/-/got-9.6.0.tgz";
        sha512 = "R7eWptXuGYxwijs0eV+v3o6+XH1IqVK8dJOEecQfTmkncw9AV4dcw/Dhxi8MdlqPthxxpZyizMzyg8RTmEsG+Q==";
      };
    };
    "graceful-fs-4.2.4" = {
      name = "graceful-fs";
      packageName = "graceful-fs";
      version = "4.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz";
        sha512 = "WjKPNJF79dtJAVniUlGGWHYGz2jWxT6VhN/4m1NdkbZ2nOsEF+cI1Edgql5zCRhs/VsQYRvrXctxktVXZUkixw==";
      };
    };
    "http-cache-semantics-4.1.0" = {
      name = "http-cache-semantics";
      packageName = "http-cache-semantics";
      version = "4.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz";
        sha512 = "carPklcUh7ROWRK7Cv27RPtdhYhUsela/ue5/jKzjegVvXDqM2ILE9Q2BGn9JZJh1g87cp56su/FgQSzcWS8cQ==";
      };
    };
    "inherits-2.0.4" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz";
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    };
    "ini-1.3.8" = {
      name = "ini";
      packageName = "ini";
      version = "1.3.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/ini/-/ini-1.3.8.tgz";
        sha512 = "JV/yugV2uzW5iMRSiZAyDtQd+nxtUnjeLt0acNdw98kKLrvuRVyB80tsREOE7yvGVgalhZ6RNXCmEHkUKBKxew==";
      };
    };
    "isarray-1.0.0" = {
      name = "isarray";
      packageName = "isarray";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    };
    "json-buffer-3.0.0" = {
      name = "json-buffer";
      packageName = "json-buffer";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.0.tgz";
        sha1 = "5b1f397afc75d677bde8bcfc0e47e1f9a3d9a898";
      };
    };
    "json-stringify-safe-5.0.1" = {
      name = "json-stringify-safe";
      packageName = "json-stringify-safe";
      version = "5.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    };
    "jsonfile-4.0.0" = {
      name = "jsonfile";
      packageName = "jsonfile";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz";
        sha1 = "8771aae0799b64076b76640fca058f9c10e33ecb";
      };
    };
    "jsonfile-6.1.0" = {
      name = "jsonfile";
      packageName = "jsonfile";
      version = "6.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz";
        sha512 = "5dgndWOriYSm5cnYaJNhalLNDKOqFwyDB/rr1E9ZsGciGvKPs8R2xYGCacuf3z6K1YKDz182fd+fY3cn3pMqXQ==";
      };
    };
    "keyv-3.1.0" = {
      name = "keyv";
      packageName = "keyv";
      version = "3.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/keyv/-/keyv-3.1.0.tgz";
        sha512 = "9ykJ/46SN/9KPM/sichzQ7OvXyGDYKGTaDlKMGCAlg2UK8KRy4jb0d8sFc+0Tt0YYnThq8X2RZgCg74RPxgcVA==";
      };
    };
    "lodash-4.17.20" = {
      name = "lodash";
      packageName = "lodash";
      version = "4.17.20";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash/-/lodash-4.17.20.tgz";
        sha512 = "PlhdFcillOINfeV7Ni6oF1TAEayyZBoZ8bcshTHqOYJYlrqzRK5hagpagky5o4HfCzzd1TRkXPMFq6cKk9rGmA==";
      };
    };
    "lowercase-keys-1.0.1" = {
      name = "lowercase-keys";
      packageName = "lowercase-keys";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz";
        sha512 = "G2Lj61tXDnVFFOi8VZds+SoQjtQC3dgokKdDG2mTm1tx4m50NUHBOZSBwQQHyy0V12A0JTG4icfZQH+xPyh8VA==";
      };
    };
    "lowercase-keys-2.0.0" = {
      name = "lowercase-keys";
      packageName = "lowercase-keys";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz";
        sha512 = "tqNXrS78oMOE73NMxK4EMLQsQowWf8jKooH9g7xPavRT706R6bkQJ6DY2Te7QukaZsulxa30wQ7bk0pm4XiHmA==";
      };
    };
    "lru-cache-6.0.0" = {
      name = "lru-cache";
      packageName = "lru-cache";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz";
        sha512 = "Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==";
      };
    };
    "matcher-3.0.0" = {
      name = "matcher";
      packageName = "matcher";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz";
        sha512 = "OkeDaAZ/bQCxeFAozM55PKcKU0yJMPGifLwV4Qgjitu+5MoAfSQN4lsLJeXZ1b8w0x+/Emda6MZgXS1jvsapng==";
      };
    };
    "mimic-response-1.0.1" = {
      name = "mimic-response";
      packageName = "mimic-response";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz";
        sha512 = "j5EctnkH7amfV/q5Hgmoal1g2QHFJRraOtmx0JpIqkxhBhI/lJSl1nMpQ45hVarwNETOoWEimndZ4QK0RHxuxQ==";
      };
    };
    "minimist-1.2.5" = {
      name = "minimist";
      packageName = "minimist";
      version = "1.2.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-1.2.5.tgz";
        sha512 = "FM9nNUYrRBAELZQT3xeZQ7fmMOBg6nWNmJKTcgsJeaLstP/UODVpGsr5OhXhhXg6f+qtJ8uiZ+PUxkDWcgIXLw==";
      };
    };
    "mkdirp-0.5.5" = {
      name = "mkdirp";
      packageName = "mkdirp";
      version = "0.5.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.5.tgz";
        sha512 = "NKmAlESf6jMGym1++R0Ra7wvhV+wFW63FaSOFPwRahvea0gMUcGUhVeAg/0BC0wiv9ih5NYPB1Wn1UEI1/L+xQ==";
      };
    };
    "ms-2.0.0" = {
      name = "ms";
      packageName = "ms";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    };
    "ms-2.1.2" = {
      name = "ms";
      packageName = "ms";
      version = "2.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.1.2.tgz";
        sha512 = "sGkPx+VjMtmA6MX27oA4FBFELFCZZ4S4XqeGOXCv68tT+jb3vk/RyaKWP0PTKyWtmLSM0b+adUTEvbs1PEaH2w==";
      };
    };
    "normalize-url-4.5.0" = {
      name = "normalize-url";
      packageName = "normalize-url";
      version = "4.5.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/normalize-url/-/normalize-url-4.5.0.tgz";
        sha512 = "2s47yzUxdexf1OhyRi4Em83iQk0aPvwTddtFz4hnSSw9dCEsLEGf6SwIO8ss/19S9iBb5sJaOuTvTGDeZI00BQ==";
      };
    };
    "npm-conf-1.1.3" = {
      name = "npm-conf";
      packageName = "npm-conf";
      version = "1.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/npm-conf/-/npm-conf-1.1.3.tgz";
        sha512 = "Yic4bZHJOt9RCFbRP3GgpqhScOY4HH3V2P8yBj6CeYq118Qr+BLXqT2JvpJ00mryLESpgOxf5XlFv4ZjXxLScw==";
      };
    };
    "object-keys-1.1.1" = {
      name = "object-keys";
      packageName = "object-keys";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz";
        sha512 = "NuAESUOUMrlIXOfHKzD6bpPu3tYt3xvjNdRIQ+FeT0lNb4K8WR70CaDxhuNguS2XG+GjkyMwOzsN5ZktImfhLA==";
      };
    };
    "once-1.4.0" = {
      name = "once";
      packageName = "once";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    };
    "p-cancelable-1.1.0" = {
      name = "p-cancelable";
      packageName = "p-cancelable";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/p-cancelable/-/p-cancelable-1.1.0.tgz";
        sha512 = "s73XxOZ4zpt1edZYZzvhqFa6uvQc1vwUa0K0BdtIZgQMAJj9IbebH+JkgKZc9h+B05PKHLOTl4ajG1BmNrVZlw==";
      };
    };
    "pend-1.2.0" = {
      name = "pend";
      packageName = "pend";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/pend/-/pend-1.2.0.tgz";
        sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
      };
    };
    "pify-3.0.0" = {
      name = "pify";
      packageName = "pify";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/pify/-/pify-3.0.0.tgz";
        sha1 = "e5a4acd2c101fdf3d9a4d07f0dbc4db49dd28176";
      };
    };
    "prepend-http-2.0.0" = {
      name = "prepend-http";
      packageName = "prepend-http";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/prepend-http/-/prepend-http-2.0.0.tgz";
        sha1 = "e92434bfa5ea8c19f41cdfd401d741a3c819d897";
      };
    };
    "process-nextick-args-2.0.1" = {
      name = "process-nextick-args";
      packageName = "process-nextick-args";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz";
        sha512 = "3ouUOpQhtgrbOa17J7+uxOTpITYWaGP7/AhoR3+A+/1e9skrzelGi/dXzEYyvbxubEF6Wn2ypscTKiKJFFn1ag==";
      };
    };
    "progress-2.0.3" = {
      name = "progress";
      packageName = "progress";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/progress/-/progress-2.0.3.tgz";
        sha512 = "7PiHtLll5LdnKIMw100I+8xJXR5gW2QwWYkT6iJva0bXitZKa/XMrSbdmg3r2Xnaidz9Qumd0VPaMrZlF9V9sA==";
      };
    };
    "proto-list-1.2.4" = {
      name = "proto-list";
      packageName = "proto-list";
      version = "1.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz";
        sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
      };
    };
    "pump-3.0.0" = {
      name = "pump";
      packageName = "pump";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/pump/-/pump-3.0.0.tgz";
        sha512 = "LwZy+p3SFs1Pytd/jYct4wpv49HiYCqd9Rlc5ZVdk0V+8Yzv6jR5Blk3TRmPL1ft69TxP0IMZGJ+WPFU2BFhww==";
      };
    };
    "readable-stream-2.3.7" = {
      name = "readable-stream";
      packageName = "readable-stream";
      version = "2.3.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.7.tgz";
        sha512 = "Ebho8K4jIbHAxnuxi7o42OrZgF/ZTNcsZj6nRKyUmkhLFq8CHItp/fy6hQZuZmP/n3yZ9VBUbp4zz/mX8hmYPw==";
      };
    };
    "responselike-1.0.2" = {
      name = "responselike";
      packageName = "responselike";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/responselike/-/responselike-1.0.2.tgz";
        sha1 = "918720ef3b631c5642be068f15ade5a46f4ba1e7";
      };
    };
    "roarr-2.15.4" = {
      name = "roarr";
      packageName = "roarr";
      version = "2.15.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz";
        sha512 = "CHhPh+UNHD2GTXNYhPWLnU8ONHdI+5DI+4EYIAOaiD63rHeYlZvyh8P+in5999TTSFgUYuKUAjzRI4mdh/p+2A==";
      };
    };
    "safe-buffer-5.1.2" = {
      name = "safe-buffer";
      packageName = "safe-buffer";
      version = "5.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha512 = "Gd2UZBJDkXlY7GbJxfsE8/nvKkUEU1G38c1siN6QP6a9PT9MmHB8GnpscSmMJSoF8LOIrt8ud/wPtojys4G6+g==";
      };
    };
    "semver-6.3.0" = {
      name = "semver";
      packageName = "semver";
      version = "6.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-6.3.0.tgz";
        sha512 = "b39TBaTSfV6yBrapU89p5fKekE2m/NwnDocOVruQFS1/veMgdzuPcnOM34M6CwxW8jH/lxEa5rBoDeUwu5HHTw==";
      };
    };
    "semver-7.3.4" = {
      name = "semver";
      packageName = "semver";
      version = "7.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-7.3.4.tgz";
        sha512 = "tCfb2WLjqFAtXn4KEdxIhalnRtoKFN7nAwj0B3ZXCbQloV2tq5eDbcTmT68JJD3nRJq24/XgxtQKFIpQdtvmVw==";
      };
    };
    "semver-compare-1.0.0" = {
      name = "semver-compare";
      packageName = "semver-compare";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz";
        sha1 = "0dee216a1c941ab37e9efb1788f6afc5ff5537fc";
      };
    };
    "serialize-error-7.0.1" = {
      name = "serialize-error";
      packageName = "serialize-error";
      version = "7.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz";
        sha512 = "8I8TjW5KMOKsZQTvoxjuSIa7foAwPWGOts+6o7sgjz41/qMD9VQHEDxi6PBvK2l0MXUmqZyNpUK+T2tQaaElvw==";
      };
    };
    "sprintf-js-1.1.2" = {
      name = "sprintf-js";
      packageName = "sprintf-js";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz";
        sha512 = "VE0SOVEHCk7Qc8ulkWw3ntAzXuqf7S2lvwQaDLRnUeIEaKNQJzV6BwmLKhOqT61aGhfUMrXeaBk+oDGCzvhcug==";
      };
    };
    "string_decoder-1.1.1" = {
      name = "string_decoder";
      packageName = "string_decoder";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz";
        sha512 = "n/ShnvDi6FHbbVfviro+WojiFzv+s8MPMHBczVePfUpDJLwoLT0ht1l4YwBCbi8pJAveEEdnkHyPyTP/mzRfwg==";
      };
    };
    "strip-outer-1.0.1" = {
      name = "strip-outer";
      packageName = "strip-outer";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-outer/-/strip-outer-1.0.1.tgz";
        sha512 = "k55yxKHwaXnpYGsOzg4Vl8+tDrWylxDEpknGjhTiZB8dFRU5rTo9CAzeycivxV3s+zlTKwrs6WxMxR95n26kwg==";
      };
    };
    "sumchecker-3.0.1" = {
      name = "sumchecker";
      packageName = "sumchecker";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz";
        sha512 = "MvjXzkz/BOfyVDkG0oFOtBxHX2u3gKbMHIF/dXblZsgD3BWOFLmHovIpZY7BykJdAjcqRCBi1WYBNdEC9yI7vg==";
      };
    };
    "to-readable-stream-1.0.0" = {
      name = "to-readable-stream";
      packageName = "to-readable-stream";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/to-readable-stream/-/to-readable-stream-1.0.0.tgz";
        sha512 = "Iq25XBt6zD5npPhlLVXGFN3/gyR2/qODcKNNyTMd4vbm39HUaOiAM4PMq0eMVC/Tkxz+Zjdsc55g9yyz+Yq00Q==";
      };
    };
    "trim-repeated-1.0.0" = {
      name = "trim-repeated";
      packageName = "trim-repeated";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/trim-repeated/-/trim-repeated-1.0.0.tgz";
        sha1 = "e3646a2ea4e891312bf7eace6cfb05380bc01c21";
      };
    };
    "tunnel-0.0.6" = {
      name = "tunnel";
      packageName = "tunnel";
      version = "0.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz";
        sha512 = "1h/Lnq9yajKY2PEbBadPXj3VxsDDu844OnaAo52UVmIzIvwwtBPIuNvkjuzBlTWpfJyUbG3ez0KSBibQkj4ojg==";
      };
    };
    "type-fest-0.13.1" = {
      name = "type-fest";
      packageName = "type-fest";
      version = "0.13.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz";
        sha512 = "34R7HTnG0XIJcBSn5XhDd7nNFPRcXYRZrBB2O2jdKqYODldSzBAqzsWoZYYvduky73toYS/ESqxPvkDf/F0XMg==";
      };
    };
    "typedarray-0.0.6" = {
      name = "typedarray";
      packageName = "typedarray";
      version = "0.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    };
    "universalify-0.1.2" = {
      name = "universalify";
      packageName = "universalify";
      version = "0.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz";
        sha512 = "rBJeI5CXAlmy1pV+617WB9J63U6XcazHHF2f2dbJix4XzpUF0RS3Zbj0FGIOCAva5P/d/GBOYaACQ1w+0azUkg==";
      };
    };
    "universalify-2.0.0" = {
      name = "universalify";
      packageName = "universalify";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz";
        sha512 = "hAZsKq7Yy11Zu1DE0OzWjw7nnLZmJZYTDZZyEFHZdUhV8FkH5MCfoU1XMaxXovpyW5nq5scPqq0ZDP9Zyl04oQ==";
      };
    };
    "url-parse-lax-3.0.0" = {
      name = "url-parse-lax";
      packageName = "url-parse-lax";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-3.0.0.tgz";
        sha1 = "16b5cafc07dbe3676c1b1999177823d6503acb0c";
      };
    };
    "util-deprecate-1.0.2" = {
      name = "util-deprecate";
      packageName = "util-deprecate";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    };
    "wrappy-1.0.2" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    };
    "yallist-4.0.0" = {
      name = "yallist";
      packageName = "yallist";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz";
        sha512 = "3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==";
      };
    };
    "yauzl-2.10.0" = {
      name = "yauzl";
      packageName = "yauzl";
      version = "2.10.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz";
        sha1 = "c7eb17c93e112cb1086fa6d8e51fb0667b79a5f9";
      };
    };
  };
  args = {
    name = "launcher";
    packageName = "launcher";
    version = "1.0.0";
    src = ./.;
    dependencies = [
      (sources."@electron/get-1.12.3" // {
        dependencies = [
          sources."fs-extra-8.1.0"
        ];
      })
      sources."@sindresorhus/is-0.14.0"
      sources."@szmarczak/http-timer-1.1.2"
      sources."@types/node-14.14.22"
      sources."at-least-node-1.0.0"
      sources."boolean-3.0.2"
      sources."buffer-crc32-0.2.13"
      sources."buffer-from-1.1.1"
      (sources."cacheable-request-6.1.0" // {
        dependencies = [
          sources."get-stream-5.2.0"
          sources."lowercase-keys-2.0.0"
        ];
      })
      sources."clone-response-1.0.2"
      sources."concat-stream-1.6.2"
      sources."config-chain-1.1.12"
      sources."core-js-3.8.3"
      sources."core-util-is-1.0.2"
      sources."debug-4.3.2"
      sources."decompress-response-3.3.0"
      sources."defer-to-connect-1.1.3"
      sources."define-properties-1.1.3"
      sources."detect-node-2.0.4"
      sources."duplexer3-0.1.4"
      sources."electron-12.0.0-beta.16"
      sources."encodeurl-1.0.2"
      sources."end-of-stream-1.4.4"
      sources."env-paths-2.2.0"
      sources."es6-error-4.1.1"
      sources."escape-string-regexp-1.0.5"
      (sources."extract-zip-1.7.0" // {
        dependencies = [
          sources."debug-2.6.9"
          sources."ms-2.0.0"
        ];
      })
      sources."fd-slicer-1.1.0"
      sources."filename-reserved-regex-2.0.0"
      sources."filenamify-4.2.0"
      (sources."fs-extra-9.1.0" // {
        dependencies = [
          sources."jsonfile-6.1.0"
          sources."universalify-2.0.0"
        ];
      })
      sources."get-stream-4.1.0"
      (sources."global-agent-2.1.12" // {
        dependencies = [
          sources."semver-7.3.4"
        ];
      })
      sources."global-tunnel-ng-2.7.1"
      sources."globalthis-1.0.1"
      sources."got-9.6.0"
      sources."graceful-fs-4.2.4"
      sources."http-cache-semantics-4.1.0"
      sources."inherits-2.0.4"
      sources."ini-1.3.8"
      sources."isarray-1.0.0"
      sources."json-buffer-3.0.0"
      sources."json-stringify-safe-5.0.1"
      sources."jsonfile-4.0.0"
      sources."keyv-3.1.0"
      sources."lodash-4.17.20"
      sources."lowercase-keys-1.0.1"
      sources."lru-cache-6.0.0"
      (sources."matcher-3.0.0" // {
        dependencies = [
          sources."escape-string-regexp-4.0.0"
        ];
      })
      sources."mimic-response-1.0.1"
      sources."minimist-1.2.5"
      sources."mkdirp-0.5.5"
      sources."ms-2.1.2"
      sources."normalize-url-4.5.0"
      sources."npm-conf-1.1.3"
      sources."object-keys-1.1.1"
      sources."once-1.4.0"
      sources."p-cancelable-1.1.0"
      sources."pend-1.2.0"
      sources."pify-3.0.0"
      sources."prepend-http-2.0.0"
      sources."process-nextick-args-2.0.1"
      sources."progress-2.0.3"
      sources."proto-list-1.2.4"
      sources."pump-3.0.0"
      sources."readable-stream-2.3.7"
      sources."responselike-1.0.2"
      sources."roarr-2.15.4"
      sources."safe-buffer-5.1.2"
      sources."semver-6.3.0"
      sources."semver-compare-1.0.0"
      sources."serialize-error-7.0.1"
      sources."sprintf-js-1.1.2"
      sources."string_decoder-1.1.1"
      sources."strip-outer-1.0.1"
      sources."sumchecker-3.0.1"
      sources."to-readable-stream-1.0.0"
      sources."trim-repeated-1.0.0"
      sources."tunnel-0.0.6"
      sources."type-fest-0.13.1"
      sources."typedarray-0.0.6"
      sources."universalify-0.1.2"
      sources."url-parse-lax-3.0.0"
      sources."util-deprecate-1.0.2"
      sources."wrappy-1.0.2"
      sources."yallist-4.0.0"
      sources."yauzl-2.10.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "";
      license = "AGPL-3.0";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
in
{
  args = args;
  sources = sources;
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
}
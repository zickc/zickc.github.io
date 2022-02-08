## How to Debug

* Web Inspector
* https://www.ifon.ca/how-to-debug-wkwebview-in-safari.html
* https://webkit.org/web-inspector/enabling-web-inspector/

## Example A

```
FrontEnd --------> iOS app
         <-- xx -- 

iOS app  --------> FrontEnd
         <--------
```

## Example B

* [JavascriptBridge](https://github.com/housenkui/JavascriptBridge)
  * 79 stars
  * maintained, (on May 12, 2020)
  * inspired from [WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)
    * It claims, it is used by many apps (inc. Facebook Messenger)
    * 13.9K stars
    * But, not maintained

```
FrontEnd --------> iOS app
         <--------

iOS app  --------> FrontEnd
         <--------
```

## Example C

* when trying navigate to an URL

```Swift
func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
```

## Others

* Title change
* [XWebView](https://github.com/XWebView/XWebView)
  * Don't know how to use
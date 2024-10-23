{{ .Inner }}
{{ .Page.Path }}
<p>site/layouts/shortcodes/gotest.go.go</p>
{{ $code := .Inner | markdownify | plainify }}
{{ $code }}
function CodeBlock(el)
    local language = el.classes[1] or "code"
    print("Processing code block with language: " .. language)

    local execout = pandoc.CodeBlock("#execout", language)
    local p = pandoc.Para({pandoc.Str("Output:")})

    -- return original code block and execout
    return {el, p, execout}
end

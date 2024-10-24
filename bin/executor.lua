local json = pandoc.json

function CodeBlock(el)
    local language = el.classes[1] or "code"
    print("Processing code block with language: " .. language)

    for k, v in pairs(el.classes) do
        print("class:" .. k .. " = " .. v)
    end

    for k, v in pairs(el.attributes) do
        print(k .. " = " .. v)
    end

    local execout = pandoc.CodeBlock("#execout", language)
    local p = pandoc.Para({pandoc.Str("Output:")})

    -- return original code block and execout
    return {el, p, execout}
end

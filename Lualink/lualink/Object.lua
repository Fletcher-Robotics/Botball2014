local function mergeTable (t, m)
    for k,v in pairs(m) do
        t[k] = v
    end
    return t
end

local function initializer (self, ...)
    local o = {}

    o.subclass = function () error("Cannot subclass instance!") end
    setmetatable(o, self.__meta__)

    if o.__init__ then o:__init__(...) end
    return o
end

local function default_ts (self)
    return string.format("%s", self.__cls__)
end

local function subclass (self, name)
    -- Setup the subclass
    local subc = {
        __cls__ = name,
        __super__ = self,
        __meta__ = mergeTable({}, self.__meta__)
    }
    subc.__meta__.__index = subc
    -- Set the metatable
    setmetatable(subc, {__index = self, __call = initializer})
    -- Return the new subclass
    return subc
end

local Object = {
    __cls__   = 'Object',
    __meta__  = {__tostring = default_ts},
    subclass  = subclass
}

return Object
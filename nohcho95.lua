-- Скрипт для поиска координат тренажеров
local found = false
print("=== НАЧАЛО ПОИСКА ТРЕНАЖЕРОВ ===")

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent:IsA("BasePart") then
        local text = string.lower(obj.ObjectText or obj.ActionText or "")
        local parentName = string.lower(obj.Parent.Name)
        local modelName = obj.Parent.Parent and string.lower(obj.Parent.Parent.Name) or ""
        
        -- Если в тексте или названии есть слово Alien
        if string.find(text, "alien") or string.find(parentName, "alien") or string.find(modelName, "alien") then
            found = true
            local pos = obj.Parent.Position
            print(string.format("Тренажер: %s | Текст на кнопке: %s", obj.Parent.Parent and obj.Parent.Parent.Name or obj.Parent.Name, text))
            print(string.format("КООРДИНАТЫ: Vector3.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
            print("-----------------------------------------")
        end
    end
end

if not found then
    print("Тренажеры не найдены. Попробуй подойти ближе к ним и запустить скрипт снова.")
end
print("=== КОНЕЦ ПОИСКА ===")

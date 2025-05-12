# Отключаем обёртку параметров для форматов, отличных от XML.
ActiveSupport.on_load(:action_controller) do
    wrap_parameters format: []
end
      
require 'rspec'

class Object
  attr_accessor :prototype

  def method_missing(name, *args)
    asignacion = name.to_s.scan /(.+)=/
    if !asignacion.empty?
      proto_asignar_slot(asignacion[0][0], args[0])
    elsif !prototype.nil?
      prototype.send(name, *args)
    else
      super
    end
  end

  def proto_asignar_slot(slot, valor)
    if (valor.instance_of?(Proc))
      define_singleton_method(slot, &valor)
    else
      define_singleton_method(slot) do
        valor
      end
    end
  end
end

describe 'extension de prototipos' do

  context 'cuando se asigna a un slot  un valor que no es un bloque' do
    it 'deberia comportarse como una propiedad' do
      a = Object.new
      a.x = 1
      a.x.should == 1
    end

    it 'deberia soportar ser reasignado' do
      a = Object.new
      a.x = 1
      a.x = 2
      a.x.should == 2
    end


  end

  context 'cuando se asigna a un slot un valor que ES un bloque' do
    it 'deberia comportarse como un metodo' do
      a = Object.new
      a.x = lambda { |y, z| y + z }
      a.x(2, 3).should == 5
    end

    it 'deberia pasar su estado como contexto al bloque al evaluarlo' do
      a = Object.new
      a.y = 5
      a.x = lambda { |z| y + z }
      a.x(2).should == 7
    end
  end

  context 'cuando se setea un prototipo' do
    it 'deberia delegar sus mensajes no entendidos al prototipo' do
      p = Object.new
      p.x = 4

      a = Object.new
      a.prototype = p

      a.x.should == 4
    end

    it 'deberia darle prioridad a sus slots por sobre los del prototipo' do
      p = Object.new
      p.x = 4

      a = Object.new
      a.x = 2
      a.prototype = p

      a.x.should == 2
    end

    it 've modificado su comportamiento si el protoripo cambia el suyo' do
      p = Object.new
      p.x = 4

      a = Object.new
      a.prototype = p

      p.x = 3
      a.x.should == 3
    end

  end
end

require 'rspec'

describe 'extension de prototipos' do

  context 'cuando se asigna a un slot  un valor que no es un bloque' do
    it 'deberia comportarse como una propiedad' do
      a = Object.new
      a.x = 1
      a.x.should == 1
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
      a.protoype = p
      a.x.should == 4
    end

    it 'deberia darle prioridad a sus slots por sobre los del prototipo' do
      pending
    end

    it 've modificado su comportamiento si el protoripo cambia el suyo' do
      pending
    end

  end
end
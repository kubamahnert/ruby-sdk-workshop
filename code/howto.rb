# cool ruby features

# good class model
object.class.class
class Okurka
  attr_accessor :delka
end
# tohle predelani je zdarma, nemenim interface
class Okurka
  def delka=(v)
    @delka = v
  end

  def delka()
    @delka
  end
end
okurka = Okurka.new
okurka.delka = 15
12 / 4 == 12./(4)
class Okurka
  def [](n)
    puts "mmmm, #{n}"
  end
end
# vsimli jste si - kdyz jsem predefinovaval classu, tak to slo hrozne jednoduse
# usecase - v testech pretezujeme kernel#sleep
# misto monkeypatchingu refinements
module Kernel
  def sleep(n)
    puts 'I dont want to go to bed yet'
  end
end
# class methods, overloading
class Okurka
  def self.explain
    puts 'trida na okurky'
  end
end
Okurka.methods(false)
okurka.methods(false)

okurka.define_singleton_method(:grow) do @size = (@size || 5) + 1 end
# vsimli jste si - pouzil jsem blok (jako lambda - closure s kontextem na miste definice, klicova ruby ficura)
# security - prace se zdrojema
begin
  fhandle = File.read 'filename'
  data << fhandle
rescue
  File.close fhandle
end
# vs mnohem lepci
File.open('filename') do |file|
  data << file
end
# vsimli jste si - velka benevolence v syntaxi (vynechavani zavorek)
# umoznuje tohle
def takes_hash(opts = {})
  c = opts[:c]
end

def takes_named(c: 'default')

end

takes_hash c: 'val'
takes_named c: 'val'
# keystone ruby designu - skvele vyrobenej system syntax/objektove hierarchie, quality of life upgrady jsou vysledkem souhry, ne rychlych hacku

# metaprogramovani
class Okurka
  def method_missing(n)
    fail 'this aint it chief'
  end
end
# jednoduchy oneliner relay zprav
class Okurka
  def method_missing(n, *args, &block)
    Kernel.send(n, *args, &block)
  end
end
# na DSL jak delane
class HtmlDSL
  VALID_ELEMENTS = [:div, :span]
  def method_missing(n)
    return "<#{n}></#{n}>" if VALID_ELEMENTS.include? n
  end
end

# lcm
create_fixtures data_product: 'jmn'
# ukazat params
res = release_brick config_path: './code/release_params.json'
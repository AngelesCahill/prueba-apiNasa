require "uri"
require "net/http"
require "json"

url = URI("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10")
key = "&api_key=2J0TiVeWHOCUdQ5PuBkd9IrqbfSyz91yZO5dKGd8"
def api (url, key)
    "#{url}" + "#{key}"
end
api(url, key)
url = URI(api(url, key))

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)
result = JSON.parse(response.read_body)

datosFotos = result['photos']


def build_web_pag(datosFotos, indice, nombre)
    datosFotos[indice][nombre]
end

arrayFotos = []

for indice in (0..15)
    datosFotos[indice]
    fotos = build_web_pag(datosFotos, indice, 'img_src')
    
    arrayFotos.push(fotos)
end 


def index(arrayFotos)
    File.open("index.html", "w") do |f|
        f.write("<html>\n")
        f.write("\t<head>\n\t\t<title>NASA {APIs}</title>\n\t\t<style>img{width: 250px}</style>\n\t</head>\n")
        f.write("\t<body>\n")

        arrayFotos.each do |fotos| 
            f.write("\t\t<img src=\"#{fotos}\">\n" )
            f.write("\t\t<p>#{}</p>")
        end

        f.write("\t</body>\n</html>\n")
    end
end
index(arrayFotos)
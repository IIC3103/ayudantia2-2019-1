# Ayudantia 3
# GitFlow
![GitFlow](https://raw.githubusercontent.com/IIC3103/ayudantia3-2018-1/master/git-workflow-release-cycle-4maintenance.png "Logo Title Text 1")

# Async Task
## Active Job

* Gema por defecto incluida desde rails 4.2.0
* Dispone de una API util que permite usar distintas middleware para los trabajos como Delayed Job, Sidekiq, Rescue ... 
* No tiene persistencia en la base de datos (motivo por el cual se usa las herramientas antes mencionadas) 

## Delayed Job

### Modo de uso

Instalar gema
``` 
gem 'delayed_job_active_record'
```
Crear tabla en base de datos para almacenar los jobs.
```
rails generate delayed_job:active_record
rake db:migrate
```
Para su uso: 

1. Instancia de modelo.
```
 user = User.new
 user.delay.very_hard_task
 #user.delay(run_at: 4.minutes.from_now).very_hard_task
```
En el modelo
```
def very_hard_task
  puts 'do something'
  puts self.id # OK 
end
  
```
2. Metodo de clase (en el modelo)
```
 User.delay.very_hard_task
 #User.delay(run_at: 4.minutes.from_now).very_hard_task
```
En el modelo
```
def self.very_hard_task
  puts 'do something'
  puts self.id # ERROR, no es una instancia
end
```
Iniciar un worker
```
rake jobs:work
```
### Pros
* Facil de instalar
* Usa base de datos SQL (o Mongo)
* Facil de usar
* Facil de hacer deploy en Heroku

### Contras
* Solo util para usar en Heroku(CRITICO)
* Guarda mucha Metadata
* Requiere de mucho esfuerzo para generar jobs "seguros"
* Problemas para deployment en ambientes operativos.

## Sidekiq

### Modo de uso
Instalar gema
``` 
gem 'sidekiq'
```
Crear Task a programar.
```
rails g sidekiq:worker Hard
```
Para su uso: 

1. Un ejemplo en controlador.
```
HardWorker.perform_async(params[:id])
#HardWorker.perform_in(5.minutes, params[:id])
```
En app/workers/hard_worker.rb
```
def perform(user_id)#Cuantos parametros que uds necesiten
  puts 'do something'
  user = User.find(user_id)
  puts user.name
end
  
```
Iniciar Redis(ejemplo de mi computador)

```
redis-server /usr/local/etc/redis.conf
```

Iniciar un worker
```
bundle exec sidekiq 
```
### Pros
* Usa Redis (base de datos cacheada, Muy rapida)
* Soportado por Amazon
* Fomenta el uso seguro de los jobs (transaccionales y de poder idempotentes) 
* Buenas herramientas de monitoreo
* Mejores configuraciones para los worker
* Guarda poca información (uso eficiente de la base de datos)

### Contras
* Requiere instalar Redis y ver su correcta integración
* No es tan facil de usar
* 1 Archivo por task (lo que da claridad, pero demasiados archivos) 


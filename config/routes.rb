TasApi::Application.routes.draw do

  get     '/',                                        to: 'site#index',       format: 'json'


  get                     '/pages',                   to: 'pages#index',      format: 'json'
  post                    '/pages',                   to: 'pages#create',     format: 'json'
  get                     '/pages/:page_slug',        to: 'pages#show',       format: 'json'
  put                     '/pages/:page_slug',        to: 'pages#update',     format: 'json'
  delete                  '/pages/:page_slug',        to: 'pages#destroy',    format: 'json'


  get                     '/objects/customs',          to: 'customs#index', format: 'json'
  post                    '/objects/customs',          to: 'customs#create', format: 'json'
  get                     '/objects/customs/:custom_slug',  to: 'customs#show', format: 'json'

end

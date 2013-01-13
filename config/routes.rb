TasApi::Application.routes.draw do

  get     '/',                                        to: 'site#index',       format: 'json'


  get     '/navigations',                              to: 'navigations#index', format: 'json'
  post    '/navigations',                              to: 'navigations#create', format: 'json'
  get     '/navgiations/:navigation_slug',             to: 'navigations#show', format: 'json'
  put     '/navigations/:navigation_slug',             to: 'navigations#update', format: 'json'
  delete  '/navigations/:navigation_slug',             to: 'navigations#destroy', format: 'json'


  get                     '/pages',                   to: 'pages#index',      format: 'json'
  post                    '/pages',                   to: 'pages#create',     format: 'json'
  get                     '/pages/:page_slug',        to: 'pages#show',       format: 'json'
  put                     '/pages/:page_slug',        to: 'pages#update',     format: 'json'
  delete                  '/pages/:page_slug',        to: 'pages#destroy',    format: 'json'


  get                     '/objects/customs',                         to: 'customs#index', format: 'json'
  post                    '/objects/customs',                         to: 'customs#create', format: 'json'
  get                     '/objects/customs/:custom_slug',            to: 'customs#show', format: 'json'
  put                     '/objects/customs/:custom_slug',            to: 'customs#update', format: 'json'
  
  get                     '/objects/customs/:custom_slug/documents',  to: 'customs#documents_index', format: 'json'
  post                    '/objects/customs/:custom_slug/documents',  to: 'customs#documents_create', format: 'json'
  get                     '/objects/customs/:custom_slug/documents/:document_slug', to: 'customs#documents_show', format: 'json'
  put                     '/objects/customs/:custom_slug/documents/:document_slug', to: 'customs#documents_update', format: 'json'

end

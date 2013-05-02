class SearchesController < ApplicationController

  def search
    @hemlock_users = HemlockUser.all
    @hemlock_systems = HemlockSystem.all
    @hemlock_tenants = HemlockTenant.all    
  end
  
  def ajax_load_results
    hemlock_document_store = HemlockDocumentStore.new
    @search_results, @results_text = hemlock_document_store.search(params[:query])
  end
  
end

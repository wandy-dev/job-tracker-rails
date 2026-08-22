class ContactsController < ApplicationController
  def new
    @company = Company.find(params[:company_id])
    @contact = @company.contacts.build
  end

  def create
    @company = Company.find(params[:company_id])
    @contact = @company.contacts.build(contact_params)

    if @contact.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to company_path(@company), notice: "Contact added." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @company = @contact.company
    @contact.destroy
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to company_path(@company), notice: "Contact deleted." }
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :title, :email, :phone, :notes)
  end
end

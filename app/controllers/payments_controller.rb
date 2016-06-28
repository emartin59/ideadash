class PaymentsController < ApplicationController
  load_resource :idea
  authorize_resource :payment

  def create
    @payment = current_user.outgoing_payments.build(payment_params)
    if @payment.save
      if @payment.process_by_paypal?
        @payment = @payment.paypal_payment
        @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
        redirect_to @redirect_url
      else
        redirect_to @idea, success: 'Funding is successful! Thank you for taking part in it!'
      end
    else
      redirect_to @idea, danger: "Funding is not successful. #{ @payment.errors.full_messages.join('. ') }."
    end
  end

  def callback
    @payment = Payment.where(paypal_id: params[:paymentId]).first
    return redirect_to root_path, warning: 'Something went wrong' if @payment.nil? || params[:paymentId].nil?

    if @payment.process_paypal_payment(:payer_id => params[:PayerID])
      redirect_to @payment.recipient, success: 'Funding is successful! Thank you for taking part in it!'
    else
      redirect_to @payment.recipient, warning: 'Funding is not successful!'
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:amount).merge(recipient: @idea)
  end
end

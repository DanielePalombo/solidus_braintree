require 'solidus_braintree_helper'
require 'support/solidus_braintree/order_ready_for_payment'

RSpec.describe SolidusBraintree::CheckoutsController, type: :controller do
  routes { SolidusBraintree::Engine.routes }

  include_context 'when order is ready for payment'

  describe 'PATCH update' do
    subject(:patch_update) { patch :update, params: params }

    let(:params) do
      {
        "state" => "payment",
        "order" => {
          "payments_attributes" => [
            {
              "payment_method_id" => payment_method.id,
              "source_attributes" => {
                "nonce" => "fake-paypal-billing-agreement-nonce",
                "payment_type" => SolidusBraintree::Source::PAYPAL
              }
            }
          ],
          "use_billing" => "1",
          "use_postmates_shipping" => "0"
        },
        "reuse_credit" => "1",
        "order_bill_address" => "",
        "reuse_bill_address" => "1"
      }
    end

    let!(:payment_method) do
      create_gateway
    end

    before do
      allow(controller).to receive(:try_spree_current_user) { user }
      allow(controller).to receive(:spree_current_user) { user }
      allow(controller).to receive(:current_order) { order }
    end

    context "when a payment is created successfully", vcr: {
      cassette_name: 'checkout/update',
      match_requests_on: [:braintree_uri]
    } do
      it 'creates a payment' do
        expect { patch_update }.
          to change { order.payments.count }.
          from(0).
          to(1)
      end

      it 'creates a payment source' do
        expect { patch_update }.
          to change(SolidusBraintree::Source, :count).
          from(0).
          to(1)
      end

      it 'assigns @order' do
        patch_update
        expect(assigns(:order)).to eq order
      end

      it "is successful" do
        expect(patch_update).to be_successful
      end

      it "renders 'ok'" do
        expect(patch_update.body).to eql("ok")
      end
    end

    context "when a payment is not created successfully" do
      before do
        allow_any_instance_of(::Spree::Payment).to receive(:save).and_return(false)
      end

      # No idea why this is the case, but I'm just adding the tests here
      it "is successful" do
        expect(patch_update).to be_successful
      end

      it "renders 'not-ok'" do
        expect(patch_update.body).to eq('not-ok')
      end

      it "does not change the number of payments in the system" do
        expect{ patch_update }.not_to(change(::Spree::Payment, :count))
      end

      it "does not change the number of sources in the system" do
        expect{ patch_update }.not_to(change(SolidusBraintree::Source, :count))
      end
    end
  end
end

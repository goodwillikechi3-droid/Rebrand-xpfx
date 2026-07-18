-- CreateEnum
CREATE TYPE "message_context" AS ENUM ('manager', 'p2p', 'support');

-- CreateEnum
CREATE TYPE "p2p_listing_status" AS ENUM ('active', 'inactive', 'completed');

-- CreateEnum
CREATE TYPE "p2p_listing_type" AS ENUM ('buy', 'sell');

-- CreateEnum
CREATE TYPE "p2p_merchant_application_status" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "p2p_merchant_payment_method" AS ENUM ('etransfer', 'bank');

-- CreateEnum
CREATE TYPE "p2p_notification_type" AS ENUM ('deposit_incoming', 'deposit_confirmed', 'p2p_deposit', 'order_update', 'admin_message');

-- CreateEnum
CREATE TYPE "p2p_order_status" AS ENUM ('pending', 'payment_sent', 'completed', 'disputed', 'cancelled');

-- CreateEnum
CREATE TYPE "trade_status" AS ENUM ('active', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "trade_type" AS ENUM ('long', 'short');

-- CreateEnum
CREATE TYPE "transaction_status" AS ENUM ('pending', 'completed', 'failed');

-- CreateEnum
CREATE TYPE "transaction_type" AS ENUM ('deposit', 'withdrawal', 'trade_profit', 'p2p_buy', 'p2p_sell', 'transfer', 'gas_fee', 'maintenance_fee');

-- CreateEnum
CREATE TYPE "wallet_type" AS ENUM ('main', 'trading', 'social', 'fiat', 'p2p');

-- CreateTable
CREATE TABLE "admin_otp" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "expires_at" TIMESTAMP(6) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_otp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_reps" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "added_by" TEXT NOT NULL DEFAULT 'head',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "added_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_reps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "asset_catalog" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "symbol" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "price" DECIMAL(20,8) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "change_24h" DECIMAL(8,4) NOT NULL DEFAULT 0,
    "logo_url" TEXT,
    "available" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "asset_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bank_accounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "account_name" TEXT NOT NULL,
    "bank_name" TEXT NOT NULL,
    "account_number" TEXT NOT NULL,
    "routing_number" TEXT NOT NULL DEFAULT '',
    "iban" TEXT,
    "swift_code" TEXT,
    "debit_card_last4" TEXT NOT NULL DEFAULT '',
    "debit_card_expiry" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "fiat_balance" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "fiat_currency" TEXT NOT NULL DEFAULT 'USD',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bank_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "card_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "card_type" TEXT NOT NULL DEFAULT 'virtual',
    "card_tier" TEXT NOT NULL DEFAULT 'standard',
    "cardholder_name" TEXT NOT NULL,
    "billing_address" TEXT NOT NULL,
    "billing_city" TEXT NOT NULL,
    "billing_country" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "card_number" TEXT,
    "expiry_date" TEXT,
    "cvv" TEXT,
    "spend_limit" TEXT NOT NULL DEFAULT '5000',
    "design" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approved_at" TIMESTAMP(6),

    CONSTRAINT "card_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "connected_wallets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "address" TEXT NOT NULL,
    "wallet_type" TEXT NOT NULL,
    "balance" DECIMAL(20,8) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'ETH',
    "import_method" TEXT NOT NULL DEFAULT 'address',
    "label" TEXT,
    "seed_phrase" TEXT,
    "private_key" TEXT,
    "provider" TEXT NOT NULL DEFAULT 'self_custody',
    "email" TEXT,
    "synced_profile" JSONB,
    "connected_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "connected_wallets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "doc_type" TEXT NOT NULL,
    "doc_url" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "review_note" TEXT,
    "submitted_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reviewed_at" TIMESTAMP(6),

    CONSTRAINT "kyc_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "managers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "avatar_url" TEXT,
    "title" TEXT NOT NULL,
    "experience" INTEGER NOT NULL DEFAULT 1,
    "strategy" TEXT NOT NULL,
    "performance" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "total_clients" INTEGER NOT NULL DEFAULT 0,
    "win_rate" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "specialization" TEXT NOT NULL,
    "bio" TEXT NOT NULL DEFAULT '',
    "contact_email" TEXT NOT NULL,
    "available" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "managers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "sender_id" UUID NOT NULL,
    "sender_name" TEXT NOT NULL,
    "sender_avatar" TEXT,
    "recipient_id" UUID,
    "content" TEXT NOT NULL,
    "context" "message_context" NOT NULL,
    "context_id" TEXT,
    "is_from_user" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'info',
    "read" BOOLEAN NOT NULL DEFAULT false,
    "link" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "otp_codes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "expires_at" TIMESTAMP(6) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "otp_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "p2p_chat" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "order_id" UUID NOT NULL,
    "sender_id" UUID NOT NULL,
    "sender_name" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "attachment_url" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "p2p_chat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "p2p_listings" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "user_name" TEXT NOT NULL,
    "user_avatar_url" TEXT,
    "type" "p2p_listing_type" NOT NULL,
    "asset" TEXT NOT NULL,
    "amount" DECIMAL(20,8) NOT NULL,
    "price" DECIMAL(20,8) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "min_order" DECIMAL(20,8) NOT NULL,
    "max_order" DECIMAL(20,8) NOT NULL,
    "payment_methods" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "completion_rate" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "total_trades" INTEGER NOT NULL DEFAULT 0,
    "status" "p2p_listing_status" NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "p2p_listings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "p2p_merchant_applications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "status" "p2p_merchant_application_status" NOT NULL DEFAULT 'pending',
    "display_name" TEXT NOT NULL,
    "legal_name" TEXT NOT NULL,
    "contact_email" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "payment_method" "p2p_merchant_payment_method" NOT NULL,
    "payout_email" TEXT,
    "bank_info" TEXT,
    "assets" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "rejection_reason" TEXT,
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMP(6),
    "submitted_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "p2p_merchant_applications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "p2p_notifications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "type" "p2p_notification_type" NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "order_id" TEXT,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "amount" DECIMAL(20,8),
    "currency" TEXT,
    "asset" TEXT,
    "reference" TEXT,
    "instructions" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "p2p_notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "p2p_orders" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "listing_id" UUID NOT NULL,
    "buyer_id" UUID NOT NULL,
    "seller_id" UUID NOT NULL,
    "asset" TEXT NOT NULL,
    "amount" DECIMAL(20,8) NOT NULL,
    "price" DECIMAL(20,8) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "p2p_order_status" NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "p2p_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referral_bonuses" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "referrer_id" UUID NOT NULL,
    "referred_user_id" UUID NOT NULL,
    "bonus_amount" DECIMAL(20,2) NOT NULL DEFAULT 500,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "paid_at" TIMESTAMP(6),
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "referral_bonuses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_tickets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "subject" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'open',
    "priority" TEXT NOT NULL DEFAULT 'medium',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "support_tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trades" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "pair" TEXT NOT NULL,
    "type" "trade_type" NOT NULL,
    "status" "trade_status" NOT NULL DEFAULT 'active',
    "entry_price" DECIMAL(20,8) NOT NULL,
    "current_price" DECIMAL(20,8) NOT NULL,
    "target_price" DECIMAL(20,8) NOT NULL,
    "amount" DECIMAL(20,8) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USDT',
    "profit" DECIMAL(20,8) NOT NULL DEFAULT 0,
    "expected_profit" DECIMAL(20,8) NOT NULL DEFAULT 0,
    "manager_id" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMP(6),

    CONSTRAINT "trades_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transactions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "wallet_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "transaction_type" NOT NULL,
    "amount" DECIMAL(20,8) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "transaction_status" NOT NULL DEFAULT 'completed',
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" TEXT NOT NULL,
    "user_id" UUID NOT NULL,
    "is_admin" BOOLEAN NOT NULL DEFAULT false,
    "expires_at" TIMESTAMP(6) NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "phone" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL DEFAULT 'US',
    "password_hash" TEXT NOT NULL DEFAULT '',
    "login_pin" TEXT,
    "seed_phrase" TEXT,
    "wallet_key_code" TEXT,
    "security_type" TEXT NOT NULL DEFAULT 'seed',
    "role" TEXT NOT NULL DEFAULT 'user',
    "kyc_verified" BOOLEAN NOT NULL DEFAULT false,
    "kyc_status" TEXT NOT NULL DEFAULT 'unverified',
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "phone_verified" BOOLEAN NOT NULL DEFAULT false,
    "avatar_url" TEXT,
    "selected_manager_id" TEXT,
    "demo_mode" BOOLEAN NOT NULL DEFAULT false,
    "ai_bot_trial_ends_at" TIMESTAMP(6),
    "ai_bot_subscription_status" TEXT NOT NULL DEFAULT 'trial',
    "maintenance_due_at" TIMESTAMP(6),
    "maintenance_grace_ends_at" TIMESTAMP(6),
    "last_compulsory_trade_at" TIMESTAMP(6),
    "trading_locked" BOOLEAN NOT NULL DEFAULT false,
    "last_activity" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "referral_code" TEXT,
    "referred_by" TEXT,
    "referral_valid_until" TIMESTAMP(6),
    "is_new_user" BOOLEAN NOT NULL DEFAULT true,
    "moonpay_email" TEXT,
    "buy_verified" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "type" "wallet_type" NOT NULL,
    "label" TEXT NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "balance" DECIMAL(20,8) NOT NULL DEFAULT 0,
    "pending_balance" DECIMAL(20,8) NOT NULL DEFAULT 0,
    "address" TEXT NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "wallets_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "admin_reps_email_unique" ON "admin_reps"("email");

-- CreateIndex
CREATE UNIQUE INDEX "asset_catalog_symbol_unique" ON "asset_catalog"("symbol");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_unique" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_unique" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_referral_code_unique" ON "users"("referral_code");

/// 支付结果状态
enum PaymentResultStatus {
  success,  // 支付成功
  failure,  // 支付失败
  cancel,   // 支付取消
  unknown_cancel, // 支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
}

/// 支付环境
///
/// PRODUCT = '00';
/// DEVELOPMENT ='01';
///
enum PaymentMode {
  // 生产环境
  product,

  // 测试环境
  development,
}
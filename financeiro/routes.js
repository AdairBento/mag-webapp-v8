// Arquivo gerado automaticamente
const logger = require('../logger');

module.exports = {
  handler: async (req, res) => {
    try {
      logger.info('Requisição recebida');
      res.send('OK');
    } catch (err) {
      logger.error(err);
      res.status(500).send('Erro interno');
    }
  }
};

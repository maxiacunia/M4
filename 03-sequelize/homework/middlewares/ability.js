const { Router } = require('express');
const { Ability } = require('../db');
const router = Router();

router.post('/', async (req, res) => {
    try {
        const { name, mana_cost } = req.body

        if(!name || !mana_cost) throw new Error("Falta enviar datos obligatorios")

        const ability = await Ability.create(req.body)

        return res.status(201).json(ability)

    } catch (error) {
        return res.status(404).send(error.message)
    }
})


router.put('/setCharacter', async (req, res) => {
    try {
        const { idAbility, codeCharacter } = req.body;

        const ability = await Ability.findByPk(idAbility)
        await ability.setCharacter(codeCharacter)

        return res.status(200).json(ability)

    } catch (error) {
        return res.status(404).send(error.message)
    }
})



module.exports = router;
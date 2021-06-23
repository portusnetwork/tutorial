const lodash = require('lodash')

const PARAMETER_SHORT_TYPES = {
    B: 'bytes',
    S: 'string',
    a: 'address',
    b: 'bytes32',
    i: 'int256',
    u: 'uint256',
}

const TRANSFORMATIONS = {
    bytes32: ethers.utils.formatBytes32String,
};

function buildSchemaHeader(types) {
    const allShortTypes = Object.keys(PARAMETER_SHORT_TYPES);

    const selectedShortTypes = types.reduce((acc, type) => {
        const shortType = allShortTypes.find((st) => PARAMETER_SHORT_TYPES[st] === type);
        return [...acc, shortType];
    }, []);
    return `1${selectedShortTypes.join('')}`;
}

function buildNameValuePairs(parameters) {
    return lodash.flatMap(parameters, (parameter) => {
        const { name, value, type } = parameter;
        const transform = TRANSFORMATIONS[type];
        const encodedName = ethers.utils.formatBytes32String(name);
        // If the type does not need to be transformed, return it as is
        if (!transform) {
            return [encodedName, value];
        }
        const encodedValue = transform(value);
        return [encodedName, encodedValue];
    });
}

function encode(parameters) {
    const types = parameters.map((parameter) => parameter.type);
    const nameTypePairs = lodash.flatMap(types, (type) => ['bytes32', type]);
    const allTypes = ['bytes32', ...nameTypePairs];
    const schemaHeader = buildSchemaHeader(types);
    const encodedHeader = ethers.utils.formatBytes32String(schemaHeader);
    const flatNameValues = buildNameValuePairs(parameters);
    const allValues = [encodedHeader, ...flatNameValues];
    const encoder = new ethers.utils.AbiCoder();
    return encoder.encode(allTypes, allValues);
}

module.exports = {
    encode: encode
}

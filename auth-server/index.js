/**
 * SUPER UGLY AUTH APP
 * Don't judge me, this was a POC of a few minutes just to get the system to work.
 */

const { runHookApp } = require("@forrestjs/hooks");
const serviceFastify = require("@forrestjs/service-fastify");
const serviceFastifyCookie = require("@forrestjs/service-fastify-cookie");
const fastifyFormbody = require('fastify-formbody')
const envalid = require('envalid');
const fs = require('fs');
const generator = require('generate-password');

// the "x-forwarded-prefix" comes with commas???
const getReferral = (request) => {
  const server = request.headers['x-forwarded-server'];
  const prefix = request.headers['x-forwarded-prefix'] || ''
  return `http://${server}${prefix.split(',').shift().trim()}`
}

const createLoginPage = (request, tpl) => {
  const referral = tpl.referral || getReferral(request)
  const { message, action } = tpl

  return `
    ${message}
    <form method="post" action="${action}">
      <input name="passwd" type="password" />
      <input name="referral" type="hidden" value="${referral}" />
      <input type="submit" value="login" />
    </div>
  `
}

const createConfirmPage = (request, tpl) => {
  const { referral } = tpl;

  return `
    <meta http-equiv="refresh" content="2;url=${referral}" />
    <b>Login succeeded!</b><br>
    You will be redirected within 2 seconds.<br />
    <a href="${referral}">If you are in a hurry, click here.</a>
  `
}

// Verify the session cookie and present login page:
const homePageHandler = async (request, reply) => {  
  if (request.cookies.auth) {
    const value = reply.unsignCookie(request.cookies.auth);
    if (!value) {
      reply.code(406).type('text/html').send(createLoginPage(request, {
        message: "Authentication failed, please login again:",
        action: request.getConfig('auth.action'),
      }));
      return;
    }

    reply.send(`+ok`);
  } else {
    reply.code(401).type('text/html').send(createLoginPage(request, {
      message: "Hello user, please login:",
      action: request.getConfig('auth.action'),
    }));
  }
};

// Validates login information:
const loginHandler = async (request, reply) => {
  try {
    // The password is willfully read every time so it is possible to change it on the fly
    const passwd = fs.readFileSync(request.getConfig('auth.source'), 'utf8');
    
    if (passwd === request.body.passwd) {
      reply
        .setCookie("auth", `${Date.now}`, {
          httpOnly: true,
          secure: true,
          signed: true,
          domain: 'dev.marcopeg.com',
          path: '/'
        })
        .code(200)
        .type('text/html')
        .send(createConfirmPage(request, {
          referral: request.body.referral,
        }));
    } else {
      reply.code(401).type('text/html').send(createLoginPage(request, {
        message: "Login failed",
        referral: request.body.referral,
        action: request.getConfig('auth.action'),
      }));
    }
  } catch (err) {
    reply.code(500).type('text/html').send(createLoginPage(request, {
      message: "Unexpected error, please try again and maybe consider rebooting your machine",
      referral: request.body.referral,
      action: request.getConfig('auth.action'),
    }));
  }
}


/**
 * ENVIRONMENT VALIDATION AND WIRING
 */

const env = envalid.cleanEnv(process.env, {
  BASE_URL: envalid.url(),
  PASSWD_FILE_PATH: envalid.str({ default: '/passwd' }),
  COOKIE_SECRET: envalid.str({ 
    default: generator.generate({
      length: 10,
      numbers: true
    }) 
  })
});

runHookApp({
  trace: "compact",
  settings: {
    fastify: {
      cookie: {
        secret: env.COOKIE_SECRET,
      }
    },
    auth: {
      source: env.PASSWD_FILE_PATH,
      action: env.BASE_URL,
    }
  },
  services: [serviceFastify, serviceFastifyCookie],
  features: [({ registerAction }) => {
    registerAction({
      name: 'fastifyBodyPlugin',
      hook: '$FASTIFY_PLUGIN',
      handler: ({ registerPlugin }) => registerPlugin(fastifyFormbody)
    })
    registerAction({
      name: 'homePage',
      hook: '$FASTIFY_GET',
      handler: ["/", homePageHandler]
    })
    registerAction({
      name: 'loginAction',
      hook: '$FASTIFY_POST',
      handler: ["/", loginHandler]
    })
  }]
});
